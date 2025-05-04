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

    var
        JobTaskIdMapping: Dictionary of [Text, Integer];

    procedure JobAsJson(): JsonObject
    var
        JobRec: Record Job;
        JobTask: Record "Job Task";
        JobTaskDependency: Record "Job Task Dependency";
        out: JsonObject;
        project: JsonObject;
        task: JsonObject;
        link: JsonObject;
        tasks: JsonArray;
        links: JsonArray;
        null: JsonValue;
        id: Integer;
        parentId: Integer;
        taskParentId: Integer;
        lastTaskIdAtLevel: array[10] of Integer;
        currentIndentation: Integer;
        UniqueTaskKey: Text;
        PredecessorTaskKey: Text;
        SuccessorTaskKey: Text;
    begin
        null.SetValueToNull();
        id := 0;
        Clear(JobTaskIdMapping);

        // Parcourir tous les projets
        if JobRec.FindSet() then
        repeat
            // Ajouter le projet comme élément parent
            Clear(project);
            id += 1;
            parentId := id;

            project.Add('id', parentId);
            project.Add('text', JobRec.Description);
            project.Add('start_date', null);
            project.Add('duration', null);
            project.Add('parent', 0);
            project.Add('progress', 0);
            project.Add('open', true);
            tasks.Add(project);

            // Initialiser le suivi des niveaux
            for currentIndentation := 1 to 10 do
                lastTaskIdAtLevel[currentIndentation] := 0;
            
            lastTaskIdAtLevel[1] := parentId;

            // Ajouter les tâches du projet
            JobTask.SetRange("Job No.", JobRec."No.");
            if JobTask.FindSet() then
                repeat
                    Clear(task);
                    JobTask.CalcFields("Start Date", "End Date");

                    id += 1;
                    UniqueTaskKey := GetTaskUniqueKey(JobRec."No.", JobTask."Job Task No.");
                    
                    if not JobTaskIdMapping.ContainsKey(UniqueTaskKey) then
                        JobTaskIdMapping.Add(UniqueTaskKey, id);
                    
                    task.Add('id', id);
                    task.Add('text', JobTask.Description);

                    // Gestion des dates
                    if JobTask."Start Date" <> 0D then
                        task.Add('start_date', Format(JobTask."Start Date", 0, 9))
                    else
                        task.Add('start_date', null);

                    if (JobTask."Start Date" <> 0D) and (JobTask."End Date" <> 0D) then
                        task.Add('duration', JobTask."End Date" - JobTask."Start Date" + 1)
                    else
                        task.Add('duration', 1);

                    // Déterminer le parent selon l'indentation
                    currentIndentation := JobTask.Indentation + 1;
                    if currentIndentation > 10 then
                        currentIndentation := 10;
                        
                    taskParentId := currentIndentation <= 1 ? parentId : lastTaskIdAtLevel[currentIndentation - 1];
                    task.Add('parent', taskParentId);
                    lastTaskIdAtLevel[currentIndentation] := id;
                    
                    task.Add('progress', 0);
                    task.Add('open', true);
                    tasks.Add(task);
                until JobTask.Next() = 0;

            // Ajouter les dépendances entre tâches
            JobTaskDependency.SetRange("Job No.", JobRec."No.");
            if JobTaskDependency.FindSet() then
                repeat
                    SuccessorTaskKey := GetTaskUniqueKey(JobRec."No.", JobTaskDependency."Job Task No.");
                    PredecessorTaskKey := GetTaskUniqueKey(JobRec."No.", JobTaskDependency."Predecessor Job Task No.");
                    
                    if JobTaskIdMapping.ContainsKey(SuccessorTaskKey) and 
                       JobTaskIdMapping.ContainsKey(PredecessorTaskKey) then
                    begin
                        Clear(link);
                        link.Add('id', JobTaskDependency."Line No.");
                        link.Add('source', JobTaskIdMapping.Get(PredecessorTaskKey));
                        link.Add('target', JobTaskIdMapping.Get(SuccessorTaskKey));
                        link.Add('type', GetDependencyTypeAsNumber(JobTaskDependency."Dependency Type"));
                        links.Add(link);
                    end;
                until JobTaskDependency.Next() = 0;
        until JobRec.Next() = 0;

        out.Add('data', tasks);
        out.Add('links', links);
        exit(out);
    end;

    local procedure GetTaskUniqueKey(JobNo: Code[20]; TaskNo: Code[20]): Text
    begin
        exit(StrSubstNo('%1|%2', JobNo, TaskNo));
    end;

    local procedure GetDependencyTypeAsNumber(DependencyType: Option "Finish-to-Start","Start-to-Start","Finish-to-Finish","Start-to-Finish"): Integer
    begin
        // Convertir le type de dépendance en nombre attendu par le contrôle Gantt
        // 0 = Finish-to-Start, 1 = Start-to-Start, 2 = Finish-to-Finish, 3 = Start-to-Finish
        exit(DependencyType);
    end;
}