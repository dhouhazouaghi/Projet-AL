page 50711 "Simple Cues"
{
    PageType = CardPart;
    SourceTable = Customer;
    ApplicationArea = All;
    Caption = 'Indicateurs Clients';
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            cuegroup("Clients")
            {
                field("Total Clients"; Count)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        Count: Integer;

    trigger OnOpenPage()
    begin
        Count := Rec.Count;
    end;
}