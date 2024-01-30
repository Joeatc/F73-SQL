create view Contact.Contacts
as
select Contact.Id

     , Contact.TenantId
     , Tenant.Code                                                                                    as TenantCode

     -- Common attributes
     , Contact.ContactType
     , Common.InternationalText_Get('ContactType', Contact.ContactType, Contact.ContactType,
                                    default)                                                          as ContactTypeLocal
     , Contact.Code
     , Contact.Title

     -- Person only attributes
     , Contact.NamePrefix
     , Contact.GivenName
     , Contact.AdditionalName
     , Contact.FamilyName
     , Contact.NameSuffix
     , Contact.MaidenName
     , Contact.Salutation
     , Contact.LetterSalutation
     , Contact.Gender
     , Contact.Birthday
     , Contact.Organization
     , Contact.Department
     , Contact.JobTitle

     -- Organization or venue attributes
     , Contact.FormattedName

     -- Main address
     , PostalAddress.Id                                                                               as PostalAddressId
     , PostalAddress.ResolvedLabel                                                                    as PostalAddressLabel
     , PostalAddress.Agent                                                                            as PostalAddressAgent
     , PostalAddress.POBox
     , PostalAddress.Street
     , PostalAddress.ExtendedAddress
     , PostalAddress.City
     , PostalAddress.PostCode
     , PostalAddress.CountryCode
     , PostalAddress.CountryName
     , PostalAddress.Region
     , PostalAddress.FormattedAddress
     , PostalAddress.AddressDisplay

     -- Main email address
     , Email.Id                                                                                       as EmailId
     , Email.ResolvedLabel                                                                            as EmailLabel
     , Email.Address                                                                                  as EmailAddress

     -- Standard phone numbers
     , Phone1.Id                                                                                      as Phone1Id
     , Phone1.ResolvedLabel                                                                           as Phone1Label
     , Phone1.Number                                                                                  as Phone1Number
     , Phone2.Id                                                                                      as Phone2Id
     , Phone2.ResolvedLabel                                                                           as Phone2Label
     , Phone2.Number                                                                                  as Phone2Number

     -- Preferred document communication channel
     , Contact.BusinessDocChannelId
     , BusinessDocChannels.LabelLocal                                                                 as BusinessDocChannelLocal

     -- Default language
     , Contact.LanguageCode
     , Languages.LanguageLocal

     -- User Account
     , SubjectContact.UserAccountId
     , UserAccount.SystemName                                                                         as UserAccountSysName
     , (case when SubjectContact.UserAccountId is null then 'F' else 'T' end)                         as Registered
     , Common.InternationalText_Get('System.Boolean',
                                    (case when SubjectContact.UserAccountId is null then 'F' else 'T' end), default,
                                    default)                                                          as RegisteredLocal

     -- More common attributes
     , Contact.Photo
     , Contact.Notes
     , Contact.Website
     , Contact.Updated
     , Contact.BillingMethod

     -- Identity
     , Contact.[SubjectId]
     , Contact.SyncKey


from Contact.Contact --with (index (Contact_Tenant))
         join Common.Tenant on Contact.TenantId = Tenant.Id
         left outer join Contact.BusinessDocChannels on BusinessDocChannels.Id = Contact.BusinessDocChannelId
         left outer join Common.Languages on Languages.Code = Contact.LanguageCode
         left outer join Contact.Emails as Email on Email.ContactId = Contact.Id and Email.[Primary] = 'T'
         left outer join Contact.PhoneNumbers as Phone1 on Phone1.ContactId = Contact.Id and Phone1.SequenceNo = 1
         left outer join Contact.PhoneNumbers as Phone2 on Phone2.ContactId = Contact.Id and Phone2.SequenceNo = 2
         left outer join Contact.PostalAddresses as PostalAddress
                         on PostalAddress.ContactId = Contact.Id and PostalAddress.[Primary] = 'T'
         left outer join contact.Subject on Subject.id = Contact.SubjectId
         left outer join contact.contact SubjectContact on Subject.ContactId = SubjectContact.Id
         left outer join Common.UserAccount on UserAccount.Id = SubjectContact.UserAccountId
         cross apply Common.IsCurrentTenant(Contact.TenantId, default)

where IsCurrentTenant = 1;
GO

create trigger Contact.Contacts_ioi
    on Contact.Contacts
    instead of insert
    as
begin
    set nocount on;

    -- Insert contacts
    insert into Contact.Contact
    ( Id

        -- Common attributes
    , ContactType, Code, Title

        -- Person only attributes
    , NamePrefix, GivenName, AdditionalName, FamilyName, NameSuffix
    , Salutation
    , LetterSalutation
    , Gender, Birthday
    , Organization, Department, JobTitle

        -- Organization or venue properties
    , FormattedName

        -- further standard properties
    , BusinessDocChannelId
    , LanguageCode
    , Photo, Notes, Website)
    select Id
         , ContactType
         , Code
         , IsNull(
            Title
        , (case ContactType
               when 'Person' then Concat(FamilyName, ', ', GivenName)
               else FormattedName
                end)
           )

         , NamePrefix
         , GivenName
         , AdditionalName
         , FamilyName
         , NameSuffix
         , IsNull(Salutation, Contact.BuildSalutation(NamePrefix, GivenName, FamilyName, NameSuffix))
         , LetterSalutation
         , Gender
         , Birthday
         , Organization
         , Department
         , JobTitle

         , FormattedName

         , BusinessDocChannelId
         , IsNull(LanguageCode, Common.GetSettingChar('DefaultLanguage', default))
         , Photo
         , Notes
         , Website
    from inserted;

    -- Insert primary postal address
    insert into Contact.PostalAddresses
    ( ContactId
    , ResolvedLabel
    , Agent
    , POBox, Street, ExtendedAddress, City, PostCode, CountryCode, Region
    , FormattedAddress, [Primary], Active)
    select Id
         , PostalAddressLabel
         , PostalAddressAgent
         , POBox
         , Street
         , ExtendedAddress
         , City
         , PostCode
         , CountryCode
         , Region
         , FormattedAddress
         , 'T'
         , 'T'
    from inserted
    where CountryCode is not null;

    -- Insert primary email address
    insert into Contact.Emails
        (ContactId, [Primary], ResolvedLabel, Address)
    select Id, 'T', EmailLabel, EmailAddress
    from inserted
    where EmailAddress is not null
      and Trim(EmailAddress) != '';

    -- Insert phone numbers
    insert into Contact.PhoneNumbers
        (ContactId, SequenceNo, ResolvedLabel, Number)
    select Id, 1, Phone1Label, Phone1Number
    from inserted
    where Phone1Number is not null
      and Trim(Phone1Number) != '';

    insert into Contact.PhoneNumbers
        (ContactId, SequenceNo, ResolvedLabel, Number)
    select Id, 2, Phone2Label, Phone2Number
    from inserted
    where Phone2Number is not null
      and Trim(Phone2Number) != ''
end
GO

CREATE trigger Contact.Contacts_iou
    on Contact.Contacts
    instead of update
    as
begin
    set nocount on;

    -- Nothing to do, leave
    if (select COUNT(*) from inserted) = 0
        return;

    declare @inserted varchar(max) = (select * from inserted for json path);
    print @inserted;

    -- Update contact
    merge Contact.Contact
    using (select Id
                , ContactType
                , Code
                , Title

                , NamePrefix
                , GivenName
                , AdditionalName
                , FamilyName
                , NameSuffix
                , MaidenName
                , Salutation
                , LetterSalutation
                , Gender
                , Birthday
                , Organization
                , Department
                , JobTitle

                , FormattedName

                , BusinessDocChannelId
                , LanguageCode
                , Photo
                , Notes
                , Website
           from inserted) as NewRows
    on Contact.Id = NewRows.Id
    when matched then
        update
        set Contact.ContactType          = NewRows.ContactType
          , Contact.Code                 = NewRows.Code
          , Contact.Title                = NewRows.Title

          , Contact.NamePrefix           = NewRows.NamePrefix
          , Contact.GivenName            = NewRows.GivenName
          , Contact.AdditionalName       = NewRows.AdditionalName
          , Contact.FamilyName           = NewRows.FamilyName
          , Contact.NameSuffix           = NewRows.NameSuffix
          , Contact.MaidenName           = NewRows.MaidenName
          , Contact.Salutation           = NewRows.Salutation
          , Contact.LetterSalutation     = NewRows.LetterSalutation
          , Contact.Gender               = NewRows.Gender
          , Contact.Birthday             = NewRows.Birthday
          , Contact.Organization         = NewRows.Organization
          , Contact.Department           = NewRows.Department
          , Contact.JobTitle             = NewRows.JobTitle

          , Contact.FormattedName        = NewRows.FormattedName
          , Contact.BusinessDocChannelId = NewRows.BusinessDocChannelId
          , Contact.LanguageCode         = NewRows.LanguageCode
          , Contact.Photo                = NewRows.Photo
          , Contact.Notes                = NewRows.Notes
          , Contact.Website              = NewRows.Website
          , Contact.Updated              = GetUTCDate()
        ;

    -- Update address
    merge Contact.PostalAddresses
    using (select Id
                , PostalAddressId
                , PostalAddressLabel
                , PostalAddressAgent
                , POBox
                , Street
                , ExtendedAddress
                , PostCode
                , City
                , CountryCode
                , Region
                , FormattedAddress
           from inserted
           where Coalesce(PostalAddressAgent, POBox, Street, ExtendedAddress, PostCode, City, CountryCode, Region,
                          FormattedAddress) is not null) as NewRows
    on PostalAddresses.Id = NewRows.PostalAddressId
    when matched then
        update
        set PostalAddresses.ResolvedLabel    = NewRows.PostalAddressLabel
          , PostalAddresses.Agent            = NewRows.PostalAddressAgent
          , PostalAddresses.POBox            = NewRows.POBox
          , PostalAddresses.Street           = NewRows.Street
          , PostalAddresses.ExtendedAddress  = NewRows.ExtendedAddress
          , PostalAddresses.PostCode         = NewRows.PostCode
          , PostalAddresses.City             = NewRows.City
          , PostalAddresses.CountryCode      = NewRows.CountryCode
          , PostalAddresses.Region           = NewRows.Region
          , PostalAddresses.FormattedAddress = NewRows.FormattedAddress
    when not matched by target then
        insert ( ContactId, [Primary], [Active]
               , ResolvedLabel
               , Agent
               , POBox, Street, ExtendedAddress
               , PostCode, City
               , CountryCode, Region
               , FormattedAddress)
        values ( NewRows.Id, 'T', 'T'
               , NewRows.PostalAddressLabel
               , NewRows.PostalAddressAgent
               , NewRows.POBox, NewRows.Street, NewRows.ExtendedAddress
               , NewRows.PostCode, NewRows.City
               , NewRows.CountryCode, NewRows.Region
               , NewRows.FormattedAddress)
        ;
    delete Contact.PostalAddress
    from Contact.PostalAddress p
             join inserted as c on c.PostalAddressId = p.Id
    where Coalesce(c.PostalAddressAgent
              , c.POBox, c.Street, c.ExtendedAddress, c.PostCode, c.City, c.CountryCode, c.Region
              , c.FormattedAddress) is null

    -- Update email address
    merge Contact.Emails
    using (select Id, EmailId, EmailLabel, EmailAddress
           from inserted
           where EmailAddress is not null
             and Trim(EmailAddress) != '') as NewRows
    on Emails.Id = NewRows.EmailId
    when matched then
        update
        set Emails.ResolvedLabel = NewRows.EmailLabel
          , Emails.Address       = NewRows.EmailAddress
    when not matched by target then
        insert (ContactId, [Primary], ResolvedLabel, Address)
        values (NewRows.Id, 'T', NewRows.EmailLabel, NewRows.EmailAddress)
        ;

    delete
    from Contact.Emails
    where [Primary] = 'T'
      and ContactId in
          (select inserted.id
           from inserted
           where EmailAddress is null
              or Trim(EmailAddress) = '');

    -- Update phone numbers
    declare @Numbers Contact.PhoneNumberTable;
    insert into @Numbers (Id, ContactId, Label, Number)
    select Phone1Id, Id, Phone1Label, Phone1Number
    from inserted;
    exec Contact.UpdatePhoneNumbers @Numbers, 1;

    delete from @Numbers;
    insert into @Numbers (Id, ContactId, Label, Number)
    select Phone2Id, Id, Phone2Label, Phone2Number
    from inserted;
    exec Contact.UpdatePhoneNumbers @Numbers, 2;
end
GO

create trigger Contact.Contacts_iod
    on Contact.Contacts
    instead of delete
    as
begin
    set nocount on;

    -- Delete in underlying table
    delete
    from Contact.Contact
    where Id in (select Id from deleted);

end
