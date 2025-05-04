table 50704 CustomerTable
{
    Caption = 'CustomerTable';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; City; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; PhoneNumber; Text[20])
        {
            Caption = 'Phone Number';
            DataClassification = CustomerContent;
        }
        field(5; Email; Text[100])
        {
            Caption = 'Email Address';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RegEx: Codeunit "Text Management"; // Codeunit to validate email
            begin
                if "Email" <> '' then begin
                    if not RegEx.IsValidEmail("Email") then
                        Error('Please enter a valid email address.');
                end;
            end;
        }
        field(6; Address; Text[200])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }

        field(7; ZipCode; Text[20])
        {
            Caption = 'Zip Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}