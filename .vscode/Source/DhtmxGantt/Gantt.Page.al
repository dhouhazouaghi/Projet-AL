page 50712 Gantt
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
            usercontrol(Gantt; gantt)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.Gantt.Load(JobAsJson());
                end;
            }
        }
    }
procedure JobAsJson(): JsonObject
var
    JobRec: Record Job;
    JobTask: Record "Job Task";
    JobTaskDependency: Record "Job Task Dependency";
    TaskIdMapping: Dictionary of [Text, Integer];
    out: JsonObject;
    project: JsonObject;
    task: JsonObject;
    link: JsonObject;
    tasks: JsonArray;
    links: JsonArray;
    null: JsonValue;
    id, parentId, taskParentId: Integer;
    lastTaskIdAtLevel: array[10] of Integer;
    currentIndentation: Integer;
    i: Integer;
    TaskKey: Text;
    PredecessorTaskKey: Text;
    linkId: Integer;
begin
    null.SetValueToNull();
    id := 0;
    linkId := 0; // Unique link ID counter

    // Initialize JSON output
    Clear(out);
    Clear(tasks);
    Clear(links);

    if JobRec.FindSet() then
        repeat
            Clear(project);
            id += 1;
            parentId := id;

            // Add project (job) to tasks
            project.Add('id', parentId);
            project.Add('text', JobRec.Description);
            project.Add('start_date', null);
            project.Add('duration', null);
            project.Add('parent', 0);
            project.Add('progress', 0);
            project.Add('open', true);
            tasks.Add(project);

            // Initialize hierarchy tracking array
            for i := 1 to 10 do
                lastTaskIdAtLevel[i] := 0;
            lastTaskIdAtLevel[1] := parentId;

            // Process job tasks
            JobTask.SetRange("Job No.", JobRec."No.");
            if JobTask.FindSet() then
                repeat
                    Clear(task);
                    JobTask.CalcFields("Start Date", "End Date");

                    id += 1;
                    task.Add('id', id);
                    task.Add('text', JobTask.Description);

                    // Create unique key for task mapping
                    TaskKey := StrSubstNo('%1|%2', JobRec."No.", JobTask."Job Task No.");
                    
                    // Ensure no duplicate task keys
                    if TaskIdMapping.ContainsKey(TaskKey) then
                        Error('Duplicate task key found: %1. Check Job Task table for duplicates.', TaskKey);
                    TaskIdMapping.Add(TaskKey, id);

                    // Handle start date
                    if JobTask."Start Date" <> 0D then
                        task.Add('start_date', Format(JobTask."Start Date", 0, 9)) // DD-MM-YYYY
                    else
                        task.Add('start_date', null);

                    // Calculate duration
                    if (JobTask."Start Date" <> 0D) and (JobTask."End Date" <> 0D) then
                        task.Add('duration', JobTask."End Date" - JobTask."Start Date" + 1)
                    else
                        task.Add('duration', 1);

                    // Determine parent based on indentation
                    currentIndentation := JobTask.Indentation + 1;
                    if currentIndentation > 10 then
                        currentIndentation := 10;
                        
                    if currentIndentation <= 1 then
                        taskParentId := parentId
                    else if lastTaskIdAtLevel[currentIndentation - 1] <> 0 then
                        taskParentId := lastTaskIdAtLevel[currentIndentation - 1]
                    else
                        taskParentId := parentId; // Fallback to job if no parent found

                    task.Add('parent', taskParentId);
                    lastTaskIdAtLevel[currentIndentation] := id;
                    
                    task.Add('progress', 0);
                    task.Add('open', true);
                    tasks.Add(task);
                until JobTask.Next() = 0;

            // Process dependencies and handle missing tasks
            JobTaskDependency.SetRange("Job No.", JobRec."No.");
            if JobTaskDependency.FindSet() then
                repeat
                    // Create keys for task and predecessor
                    TaskKey := StrSubstNo('%1|%2', JobTaskDependency."Job No.", JobTaskDependency."Job Task No.");
                    PredecessorTaskKey := StrSubstNo('%1|%2', JobTaskDependency."Job No.", JobTaskDependency."Predecessor Job Task No.");

                    // Check if task exists; if not, create a placeholder
                    if not TaskIdMapping.ContainsKey(TaskKey) then begin
                        JobTask.Reset();
                        JobTask.SetRange("Job No.", JobTaskDependency."Job No.");
                        JobTask.SetRange("Job Task No.", JobTaskDependency."Job Task No.");
                        if not JobTask.FindFirst() then begin
                            id += 1;
                            Clear(task);
                            task.Add('id', id);
                            task.Add('text', 'Missing Task: ' + JobTaskDependency."Job Task No.");
                            task.Add('start_date', null);
                            task.Add('duration', 1);
                            task.Add('parent', parentId);
                            task.Add('progress', 0);
                            task.Add('open', true);
                            tasks.Add(task);
                            TaskIdMapping.Add(TaskKey, id);
                            Message('Created placeholder for missing task: %1 for Job %2.', JobTaskDependency."Job Task No.", JobTaskDependency."Job No.");
                        end;
                    end;

                    // Check if predecessor task exists; if not, create a placeholder
                    if not TaskIdMapping.ContainsKey(PredecessorTaskKey) then begin
                        JobTask.Reset();
                        JobTask.SetRange("Job No.", JobTaskDependency."Job No.");
                        JobTask.SetRange("Job Task No.", JobTaskDependency."Predecessor Job Task No.");
                        if not JobTask.FindFirst() then begin
                            id += 1;
                            Clear(task);
                            task.Add('id', id);
                            task.Add('text', 'Missing Predecessor Task: ' + JobTaskDependency."Predecessor Job Task No.");
                            task.Add('start_date', null);
                            task.Add('duration', 1);
                            task.Add('parent', parentId);
                            task.Add('progress', 0);
                            task.Add('open', true);
                            tasks.Add(task);
                            TaskIdMapping.Add(PredecessorTaskKey, id);
                            Message('Created placeholder for missing predecessor task: %1 for Job %2.', JobTaskDependency."Predecessor Job Task No.", JobTaskDependency."Job No.");
                        end;
                    end;

                    // Create the link since both tasks are now guaranteed to exist in TaskIdMapping
                    Clear(link);
                    linkId += 1; // Ensure unique link ID
                    link.Add('id', linkId);
                    link.Add('source', TaskIdMapping.Get(PredecessorTaskKey));
                    link.Add('target', TaskIdMapping.Get(TaskKey));

                    // Map dependency type to Gantt format
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
                            link.Add('type', '0'); // Default to Finish-to-Start
                    end;

                    links.Add(link);
                until JobTaskDependency.Next() = 0;

        until JobRec.Next() = 0;

    // Finalize JSON output
    out.Add('data', tasks);
    out.Add('links', links);
    exit(out);
end;
}