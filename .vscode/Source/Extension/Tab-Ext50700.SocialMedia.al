tableextension 50700 "Social Media" extends Customer
{
    fields
    {
        field(50700; Facebook; Text[100])
        {
            Caption = 'Facebook';
            DataClassification = ToBeClassified;
        }
        field(50701; Instagram; Text[100])
        {
            Caption = 'Instagram';
            DataClassification = ToBeClassified;
        }
        field(50702; Linkedin; Text[100])
        {
            Caption = 'Linkedin';
            DataClassification = ToBeClassified;
        }
        field(50703; Twitter; Text[100])
        {
            Caption = 'Twitter';
            DataClassification = ToBeClassified;
        }
  
        field(50704; LoyaltyNumber; Text[20])
        {
            Caption = 'Numéro de fidélité';
        }
        field(50705; MyProgress; Integer)
        {
            Caption = 'Progress';
        }
    }
}
