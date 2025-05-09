page 50712 "Project Gantt"
{
    PageType = Card;
    Caption = 'Project';
    DataCaptionExpression = Rec.Description;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = Job;

 layout
{
    area(Content)
    {
        usercontrol(Gantt; GanttControlAddIn)
        {
            ApplicationArea = All;
            trigger ControlReady()
            begin
                CurrPage.Gantt.Load(JobAsJson());
            end;

            trigger OnTaskDelete(taskId: Text)
            begin
                if taskId = '' then
                    Error('Task ID cannot be empty.');
                DeleteJobTask(taskId);
                RefreshGantt();
            end;
        }
    }
}

actions
{
    area(Processing)
    {
        action(Refresh)
        {
            ApplicationArea = All;
            Caption = 'Refresh';
            Image = Refresh;
            ToolTip = 'Refresh the Gantt chart.';
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;

            trigger OnAction()
            begin
                CurrPage.Gantt.Load(JobAsJson());
                Message('Gantt chart refreshed successfully.');
            end;
        }

        group(Export)
        {
            Caption = 'Export';

            action(ExportToPDF)
            {
                ApplicationArea = All;
                Caption = 'Export to PDF';
                Image = ExportFile;
                ToolTip = 'Export the Gantt chart to PDF';

                trigger OnAction()
                begin
                    CurrPage.Gantt.ExportToPDF();
                end;
            }
            action(ExportToPNG)
            {
                ApplicationArea = All;
                Caption = 'Export to PNG';
                Image = ExportFile;
                ToolTip = 'Export the Gantt chart to PNG image';

                trigger OnAction()
                begin
                    CurrPage.Gantt.ExportToPNG();
                end;
            }
        }
    }
    area(Navigation)
    {
        action(OpenJobTaskList)
        {
            ApplicationArea = All;
            Caption = 'Open Job Task List';
            Image = Task;
            ToolTip = 'Open the Job Task List for the current project';

            trigger OnAction()
            var
                JobTask: Record "Job Task";
                JobTaskList: Page "Job Task List";
            begin
                JobTask.SetRange("Job No.", Rec."No.");
                JobTaskList.SetTableView(JobTask);
                JobTaskList.Run();
            end;
        }
        action(OpenJobList)
        {
            ApplicationArea = All;
            Caption = 'Open Job List';
            Image = Job;
            ToolTip = 'Open the Job List for all projects';

            trigger OnAction()
            var
                JobList: Page "Job List";
            begin
                JobList.Run();
            end;
        }
    }
}

procedure JobAsJson(): JsonObject
var
    JobRec: Record Job;
    JobTask: Record "Job Task";
    JobTaskDependency: Record "Job Task Dependency";
    TaskIdMapping: Dictionary of [Text, Text]; // Map unique key to Job Task No.
    out: JsonObject;
    project: JsonObject;
    task: JsonObject;
    link: JsonObject;
    tasks: JsonArray;
    links: JsonArray;
    null: JsonValue;
    projectId: Integer;
    parentId: Text;
    taskParentId: Text;
    lastTaskIdAtLevel: array[10] of Text;
    currentIndentation: Integer;
    i: Integer;
    TaskKey: Text;
    PredecessorTaskKey: Text;
    linkId: Integer;
begin
    null.SetValueToNull();
    projectId := 0;
    linkId := 0;

    Clear(out);
    Clear(tasks);
    Clear(links);

    if JobRec.FindSet() then
        repeat
            projectId += 1;
            parentId := Format(projectId);

            Clear(project);
            project.Add('id', parentId);
            project.Add('text', 'Project: ' + JobRec.Description);
            project.Add('start_date', null);
            project.Add('duration', null);
            project.Add('parent', 0);
            project.Add('progress', 0);
            project.Add('open', true);
            tasks.Add(project);

            for i := 1 to 10 do
                lastTaskIdAtLevel[i] := '';
            lastTaskIdAtLevel[1] := parentId;

            JobTask.SetRange("Job No.", JobRec."No.");
            if JobTask.FindSet() then
                repeat
                    Clear(task);
                    JobTask.CalcFields("Start Date", "End Date");

                    task.Add('id', JobTask."Job Task No."); // Utiliser Job Task No. comme ID
                    task.Add('text', JobTask.Description);
                    task.Add('job_no', JobRec."No.");
                    task.Add('job_task_no', JobTask."Job Task No.");

                    TaskKey := StrSubstNo('%1|%2', JobRec."No.", JobTask."Job Task No.");
                    if TaskIdMapping.ContainsKey(TaskKey) then
                        Error('Duplicate task key found: %1. Check Job Task table for duplicates.', TaskKey);
                    TaskIdMapping.Add(TaskKey, JobTask."Job Task No.");

                    if JobTask."Start Date" <> 0D then
                        task.Add('start_date', Format(JobTask."Start Date", 0, 9))
                    else
                        task.Add('start_date', null);

                    if (JobTask."Start Date" <> 0D) and (JobTask."End Date" <> 0D) then
                        task.Add('duration', JobTask."End Date" - JobTask."Start Date" + 1)
                    else
                        task.Add('duration', 1);

                    currentIndentation := JobTask.Indentation + 1;
                    if currentIndentation > 10 then
                        currentIndentation := 10;

                    if currentIndentation <= 1 then
                        taskParentId := parentId
                    else if lastTaskIdAtLevel[currentIndentation - 1] <> '' then
                        taskParentId := lastTaskIdAtLevel[currentIndentation - 1]
                    else
                        taskParentId := parentId;

                    task.Add('parent', taskParentId);
                    lastTaskIdAtLevel[currentIndentation] := JobTask."Job Task No.";

                    task.Add('progress', 0);
                    task.Add('open', true);

                    if JobTask."Job Task Type" in [JobTask."Job Task Type"::"Begin-Total", JobTask."Job Task Type"::"End-Total"] then begin
                        task.Add('type', 'milestone');
                        task.Add('custom_class', 'gantt-milestone');
                    end;

                    tasks.Add(task);
                until JobTask.Next() = 0;

            JobTaskDependency.SetRange("Job No.", JobRec."No.");
            if JobTaskDependency.FindSet() then
                repeat
                    TaskKey := StrSubstNo('%1|%2', JobTaskDependency."Job No.", JobTaskDependency."Job Task No.");
                    PredecessorTaskKey := StrSubstNo('%1|%2', JobTaskDependency."Job No.", JobTaskDependency."Predecessor Job Task No.");

                    if TaskIdMapping.ContainsKey(TaskKey) and TaskIdMapping.ContainsKey(PredecessorTaskKey) then begin
                        Clear(link);
                        linkId += 1;
                        link.Add('id', linkId);
                        link.Add('source', JobTaskDependency."Predecessor Job Task No.");
                        link.Add('target', JobTaskDependency."Job Task No.");

                        case JobTaskDependency."Dependency Type" of
                            JobTaskDependency."Dependency Type"::"Finish-to-Start":
                                link.Add('type', '0');
                            JobTaskDependency."Dependency Type"::"Start-to-Start":
                                link.Add('type', '1');
                            JobTaskDependency."Dependency Type"::"Finish-to-Finish":
                                link.Add('type', '2');
                            JobTaskDependency."Dependency Type"::"Start-to-Finish":
                                link.Add('type', '3');
                            else
                                link.Add('type', '0');
                        end;

                        links.Add(link);
                    end;
                until JobTaskDependency.Next() = 0;
        until JobRec.Next() = 0;

    out.Add('data', tasks);
    out.Add('links', links);
    exit(out);
end;

procedure RefreshGantt()
begin
    CurrPage.Gantt.Load(JobAsJson());
end;

procedure DeleteJobTask(TaskId: Text)
var
    JobTask: Record "Job Task";
    JobTaskDependency: Record "Job Task Dependency";
begin
    JobTask.SetRange("Job Task No.", TaskId);
    if not JobTask.FindFirst() then
        Error('Task with Job Task No. %1 not found.', TaskId);

    // Supprimer toutes les dépendances où la tâche est un successeur
    JobTaskDependency.SetRange("Job No.", JobTask."Job No.");
    JobTaskDependency.SetFilter("Job Task No.", JobTask."Job Task No.");
    JobTaskDependency.DeleteAll();

    // Supprimer toutes les dépendances où la tâche est un prédécesseur
    JobTaskDependency.SetRange("Job Task No."); // Réinitialiser le filtre
    JobTaskDependency.SetRange("Predecessor Job Task No.", JobTask."Job Task No.");
    JobTaskDependency.DeleteAll();

    // Supprimer la tâche
    JobTask.Delete(true);
    Message('Task %1 deleted successfully.', TaskId);
end;
}