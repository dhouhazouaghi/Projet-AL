report 50701 "Employe Report"
{
    Caption = 'Liste des Employés';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts/EmployeReport.rdl';

    dataset
    {
        dataitem(EmployeData; Employe)
        {
            DataItemTableView = sorting("EmployeID");

            column(EmployeID; "EmployeID") { }
            column(Nom; Nom) { }
            column(Prenom; Prenom) { }
            column(DateNaissance; "DateNaissance") { }
            column(Poste; "Poste") { }
            column(Salaire; "Salaire") { }
            column(DepartementID; "DepartementID") { }
            column(Email; "Email") { }
            column(NumeroTelephone; "Numéro de Téléphone") { }
            column(ReportTitle; ReportTitle) { }
        }
    }
trigger OnPreReport()
begin
    ReportTitle := 'Liste des Employés';
end;



var
    ReportTitle: Text[50];
    }