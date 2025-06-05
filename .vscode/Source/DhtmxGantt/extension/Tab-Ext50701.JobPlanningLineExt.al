namespace ALProject.ALProject;

using Microsoft.Projects.Project.Planning;

tableextension 50701 "Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        field(50100; "Progress Rate"; Decimal)
        {
            Caption = 'Progress Rate';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
    field(50101; "Progress Status"; Text[20])
        {
            Caption = 'Progress Status';
            Editable = false;
        }
    }
}
