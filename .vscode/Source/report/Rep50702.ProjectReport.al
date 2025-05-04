report 50702 "Project Report"
{
    Caption = 'Project Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = 'Layouts/ProjectRRRR.docx';

    dataset
    {
        dataitem(ProjectData; Project)
        {
            DataItemTableView = sorting("ProjectID");

            column(ProjectID; "ProjectID") { }
            column(Nom; "Nom") { }
            column(Description; "Description") { }
            column(StartDate; "StartDate") { }
            column(EndDate; "EndDate") { }
            column(Budget; "Budget") { }
            column(Status; "Status") { }
        }
    }
    trigger OnPreReport()
begin
    ReportTitle := 'Liste des Projets';
end;



var
    ReportTitle: Text[50];
}