report 50700 "Bank Account List"
{
    Caption = 'Bank Account List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;  
    RDLCLayout = 'Layouts/bankacclist.rdl';

//     dataset
//     {
//         dataitem(BankData; "Bank")  
//         {
//             DataItemTableView = sorting("No.");
//             // RequestFilterFields = "Bank Branch No.";

//             column(BankNo; "No.") { }
//             column(BankName; Name) { }
//             column(BankBranch; "Bank Branch No.") { }
//             column(BankBalance; "Balance (LCY)") { }
//             column(CompanyName; CompanyName) { }
//             column(CompanyPic; BankData.CompanyName) { }

//         }
//     }

//    trigger OnPreReport()
//     begin
//         CompanyInfo.Get;
//         CompanyInfo.CalcFields(Picture);
    
//     end;
// var 
// CompanyInfo: Record "Company Information";
// Bank_Report_Label : label 'Bank Account Report';
}