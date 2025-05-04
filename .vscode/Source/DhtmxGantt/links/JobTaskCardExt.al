namespace ALProject.ALProject;

using Microsoft.Projects.Project.Job;

pageextension 50701 JobTaskCardExt extends "Job Task Card"
{
    layout
    {
        addafter(General)
        {
            part(JobTaskDependencies; "Job Task Dependencies")
            {
                ApplicationArea = All;
                SubPageLink = "Job No." = field("Job No."),
                              "Job Task No." = field("Job Task No.");
            }
        }
    }
}
