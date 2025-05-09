pageextension 50702 "JobListGanttExtension" extends "Job List"
{
    actions
    {
        addafter("Co&mments")
        {
            action(ShowGantt)
            {
                ApplicationArea = Jobs;
                Caption = 'Show &Gantt Chart';
                Image = GanttChart;
                ToolTip = 'Open interactive Gantt chart for project planning';

                trigger OnAction()
                begin
                    if Rec."No." = '' then exit;
                    Page.Run(Page::"Project Gantt", Rec);
                end;
            }
        }
    }
}