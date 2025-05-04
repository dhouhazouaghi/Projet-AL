namespace Permission;

permissionset 50700 GeneratedPermission2
{
    Assignable = true;
    Permissions = tabledata Bank=RIMD,
        tabledata CustomerTable=RIMD,
        tabledata Departement=RIMD,
        tabledata Employe=RIMD,
        tabledata Project=RIMD,
        tabledata "Work Hours"=RIMD,
        table Bank=X,
        table CustomerTable=X,
        table Departement=X,
        table Employe=X,
        table Project=X,
        table "Work Hours"=X,
        report "Bank Account List"=X,
        report "Employe Report"=X,
        report "Project Report"=X,
        codeunit "Text Management"=X,
        page "Bank List"=X,
        page DepartementCard=X,
        page DepartementPage=X,
        page "Employe Card"=X,
        page "Employee ListPart"=X,
        page EmployePage=X,
        page MyCustomerCardPage=X,
        page MyRoleCenter=X,
        page ProjectDocuumentPage=X,
        page ProjectListPage=X,
        page "Simple Cues"=X,
        page "Work Hours Worksheet"=X;
}