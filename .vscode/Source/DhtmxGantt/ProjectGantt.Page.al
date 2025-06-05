page 50712 "Project Gantt"
{
    PageType = Card;
    Caption = 'Project Timeline';
    DataCaptionExpression = 'Gantt Chart - Project Planning';
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = Job;
    PromotedActionCategories = 'New,Process,Export,Gantt,Tasks,View';

    layout
    {
        area(Content)
        {
            usercontrol(Gantt; GanttControlAddIn)
            {
                ApplicationArea = All;
                // Trigger mis à jour
                trigger ControlReady()
                var
                    GanttData: JsonObject;
                    ResourcesArray: JsonArray;
                begin
                    // Récupérer les données du diagramme Gantt (tâches)
                    GanttData := JobAsJson();

                    // Récupérer les données des ressources directement comme tableau
                    ResourcesArray := ResourceAsJson();

                    // Ajouter les ressources au JSON du diagramme Gantt
                    GanttData.Add('resources', ResourcesArray);

                    // Charger les données complètes dans le diagramme Gantt
                    CurrPage.Gantt.Load(GanttData);
                end;

                trigger OnTaskDelete(taskId: Text)
                begin
                    if taskId = '' then
                        Error('Task ID cannot be empty.');
                    DeleteJobTask(taskId);
                    RefreshGantt();
                end;

                trigger OnTaskUpdate(taskData: JsonObject)
                begin
                    UpdateJobTask(taskData);
                    RefreshGantt();
                end;

                trigger OnLinkDelete(linkData: JsonObject)
                var
                    linkId: Text;
                    sourceTask: Text;
                    targetTask: Text;
                    JsonToken: JsonToken;
                begin
                    // Extraire les informations du lien
                    if linkData.Get('id', JsonToken) then
                        linkId := JsonToken.AsValue().AsText();

                    if linkData.Get('source', JsonToken) then
                        sourceTask := JsonToken.AsValue().AsText();

                    if linkData.Get('target', JsonToken) then
                        targetTask := JsonToken.AsValue().AsText();

                    // Appeler la procédure de suppression
                    if (sourceTask <> '') and (targetTask <> '') then begin
                        DeleteLink(sourceTask, targetTask);
                        RefreshGantt();
                    end else
                        Error('Invalid link data received.');
                end;

                trigger OnLinkCreate(linkData: JsonObject)
                var
                    sourceTask: Text;
                    targetTask: Text;
                    linkType: Text;
                    JsonToken: JsonToken;
                begin
                    // Extraire les informations du nouveau lien
                    if linkData.Get('source', JsonToken) then
                        sourceTask := JsonToken.AsValue().AsText();

                    if linkData.Get('target', JsonToken) then
                        targetTask := JsonToken.AsValue().AsText();

                    if linkData.Get('type', JsonToken) then
                        linkType := JsonToken.AsValue().AsText()
                    else
                        linkType := '0'; // Par défaut: Finish-to-Start

                    // Valider les données
                    if (sourceTask = '') or (targetTask = '') then
                        Error('Invalid link data: source and target tasks are required.');

                    // Créer le lien
                    CreateLink(sourceTask, targetTask, linkType);

                    // Rafraîchir le diagramme
                    RefreshGantt();
                end;
            }
        }
    }

 actions
{
    area(Processing)
    {
        // Task Management Group
        group("Task Management")
        {
            Caption = 'Task Management';

            action(AddTask)
            {
                ApplicationArea = All;
                Caption = 'Add Task';
                Image = Add;
                ToolTip = 'Add a new task to the project';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Add Task function to be implemented');
                end;
            }

            action(EditTask)
            {
                ApplicationArea = All;
                Caption = 'Edit Task';
                Image = Edit;
                ToolTip = 'Edit the selected task';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Edit Task function to be implemented');
                end;
            }

            action(DeleteTask)
            {
                ApplicationArea = All;
                Caption = 'Delete Task';
                Image = Delete;
                ToolTip = 'Delete the selected task';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Delete Task function to be implemented');
                end;
            }

            action(AddDependency)
            {
                ApplicationArea = All;
                Caption = 'Task Dependencies';
                Image = LinkAccount;
                ToolTip = 'Add a dependency between tasks';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Add Dependency function to be implemented');
                end;
            }
        }

        // Visualization Group
        group("Visualization")
        {
            Caption = 'Visualization';

            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the Gantt chart';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CurrPage.Gantt.Load(JobAsJson());
                 //   Message('Gantt chart successfully refreshed.');
                end;
            }

            action(ZoomIn)
            {
                ApplicationArea = All;
                Caption = 'Zoom In';
                Image = ViewPostedOrder;
                ToolTip = 'Zoom in on the Gantt chart';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                CurrPage.Gantt.ZoomIn();
                end;
            }

            action(ZoomOut)
            {
                ApplicationArea = All;
                Caption = 'Zoom Out';
                Image = RelatedInformation;
                ToolTip = 'Zoom out on the Gantt chart';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                CurrPage.Gantt.ZoomOut();
                end;
            }

            action(FitToScreen)
            {
                ApplicationArea = All;
                Caption = 'Fit to Screen';
                Image = Dimensions;
                ToolTip = 'Adjust the Gantt chart to fit the screen';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    // CurrPage.Gantt.FitToScreen();
                end;
            }
        }

        // Reports Group
        group("Reports")
        {
            Caption = 'Reports';

            action(ExportToPDF)
            {
                ApplicationArea = All;
                Caption = 'Export to PDF';
                Image = SendAsPDF;
                ToolTip = 'Export the Gantt chart to PDF';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CurrPage.Gantt.ExportGanttToPDF();
                end;
            }

            action(ExportToPNG)
            {
                ApplicationArea = All;
                Caption = 'Export to PNG';
                Image = Picture;
                ToolTip = 'Export the Gantt chart as a PNG image';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CurrPage.Gantt.ExportToPNG();
                end;
            }

            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                ToolTip = 'Export project data to Excel';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    // CurrPage.Gantt.ExportToExcel();
                end;
            }

            action(ProjectReport)
            {
                ApplicationArea = All;
                Caption = 'Project Report';
                Image = Report;
                ToolTip = 'Generate a detailed project report';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Project Report function to be implemented');
                end;
            }

            action(ResourceReport)
            {
                ApplicationArea = All;
                Caption = 'Resource Report';
                Image = ResourcePlanning;
                ToolTip = 'Generate a report on resource usage';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Resource Report function to be implemented');
                end;
            }
        }

        // Collaboration Group
        group("Collaboration")
        {
            Caption = 'Collaboration';

            action(ShowCriticalPath)
            {
                ApplicationArea = All;
                Caption = 'Show Critical Path';
                Image = Flow;
                ToolTip = 'Highlight the critical path in the Gantt chart';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    // CurrPage.Gantt.ShowCriticalPath(true);
                end;
            }

            action(HideCriticalPath)
            {
                ApplicationArea = All;
                Caption = 'Hide Critical Path';
                Image = CancelLine;
                ToolTip = 'Hide the critical path in the Gantt chart';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    // CurrPage.Gantt.ShowCriticalPath(false);
                end;
            }
        }

        // New Group
        group("New")
        {
            Caption = 'New';

            action(NewProject)
            {
                ApplicationArea = All;
                Caption = 'New Project';
                Image = NewDocument;
                ToolTip = 'Create a new project';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('New Project function to be implemented');
                end;
            }

            action(DuplicateProject)
            {
                ApplicationArea = All;
                Caption = 'Duplicate Project';
                Image = Copy;
                ToolTip = 'Create a copy of the current project';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Duplicate Project function to be implemented');
                end;
            }

            action(ImportFromTemplate)
            {
                ApplicationArea = All;
                Caption = 'Import from Template';
                Image = Template;
                ToolTip = 'Create a project from an existing template';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Import from Template function to be implemented');
                end;
            }
        }
    }

    // Navigation Area
    area(Navigation)
    {
        group("Project Navigation")
        {
            Caption = 'Project Navigation';

            action(OpenJobTaskList)
            {
                ApplicationArea = All;
                Caption = 'Task List';
                Image = Task;
                ToolTip = 'Open the task list of the current project';

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobTaskList: Page "Job Task List";
                begin
                    JobTaskList.Run();
                end;
            }

            action(OpenJobList)
            {
                ApplicationArea = All;
                Caption = 'Project List';
                Image = Job;
                ToolTip = 'Open the list of all projects';

                trigger OnAction()
                var
                    JobList: Page "Job List";
                begin
                    JobList.Run();
                end;
            }

            action(OpenResourceList)
            {
                ApplicationArea = All;
                Caption = 'Resource List';
                Image = Resource;
                ToolTip = 'Open the list of project resources';

                trigger OnAction()
                var
                    ResourceList: Page "Resource List";
                begin
                    ResourceList.Run();
                end;
            }

            action(OpenBudget)
            {
                ApplicationArea = All;
                Caption = 'Project Budget';
                Image = CalculateBalanceAccount;
                ToolTip = 'Open the budget of the current project';

                trigger OnAction()
                begin
                    Message('Open Budget function to be implemented');
                end;
            }

            action(OpenRiskRegister)
            {
                ApplicationArea = All;
                Caption = 'Risk Register';
                Image = Warning;
                ToolTip = 'Open the risk register of the project';

                trigger OnAction()
                begin
                    Message('Open Risk Register function to be implemented');
                end;
            }
        }
    }}

    // Dans la procédure JobAsJson(), modifier la partie création du projet :
    procedure JobAsJson(): JsonObject
    var
        JobRec: Record Job;
        JobTask: Record "Job Task";
        JobTaskDependency: Record "Job Task Dependency";
        Employee: Record Employee; // Ajouter cette variable
        TaskIdMapping: Dictionary of [Text, Text];
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
        TaskOwners: Text;
        PersonResponsible: Text; // Ajouter cette variable
        JsonText: Text;
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

                // Récupérer le nom de la Person Responsible
                PersonResponsible := '';
                if JobRec."Person Responsible" <> '' then begin
                    if Employee.Get(JobRec."Person Responsible") then
                        PersonResponsible := Employee."First Name" + ' ' + Employee."Last Name"
                    else
                        PersonResponsible := JobRec."Person Responsible";
                end;

                Clear(project);
                project.Add('id', parentId);
                project.Add('text', 'Project: ' + JobRec.Description);
                project.Add('start_date', null);
                project.Add('duration', null);
                project.Add('parent', 0);
                project.Add('progress', 0);
                project.Add('open', true);
                project.Add('type', 'project');
                project.Add('owner', PersonResponsible); // Ajouter cette ligne
                project.Add('job_no', JobRec."No."); // Ajouter le numéro de projet
                tasks.Add(project);

                for i := 1 to 10 do
                    lastTaskIdAtLevel[i] := '';
                lastTaskIdAtLevel[1] := parentId;

                // ... le reste du code reste identique
                JobTask.SetRange("Job No.", JobRec."No.");
                if JobTask.FindSet() then
                    repeat
                        Clear(task);
                        JobTask.CalcFields("Start Date", "End Date");

                        task.Add('id', JobTask."Job Task No.");
                        task.Add('text', JobTask.Description);
                        task.Add('job_no', JobRec."No.");
                        task.Add('job_task_no', JobTask."Job Task No.");

                        // Récupérer les propriétaires (resources) pour cette tâche
                        TaskOwners := GetTaskOwners(JobRec."No.", JobTask."Job Task No.");
                        task.Add('owner', TaskOwners);
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
                        tasks.Add(task);
                    until JobTask.Next() = 0;

                // ... le reste du code pour les dépendances reste identique
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
        //  out.WriteTo(JsonText);
        //  Message('JSON généré : %1', JsonText);
        exit(out);
    end;

    procedure GetTaskOwners(JobNo: Code[20]; JobTaskNo: Code[20]): Text
    var
        JobPlanningLine: Record "Job Planning Line";
        Resource: Record Resource;
        ResourcesDict: Dictionary of [Text, Text];
        ResourceName: Text;
        ResourceFullName: Text;
        ResourceList: Text;
    begin
        Clear(ResourcesDict);
        Clear(ResourceList);

        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", JobNo);
        JobPlanningLine.SetRange("Job Task No.", JobTaskNo);
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);

        if JobPlanningLine.FindSet() then
            repeat
                ResourceName := JobPlanningLine."No.";

                // Obtenir le nom complet de la ressource
                if Resource.Get(ResourceName) then
                    ResourceFullName := Resource.Name
                else
                    ResourceFullName := ResourceName;

                // Éviter les doublons
                if not ResourcesDict.ContainsKey(ResourceName) then begin
                    ResourcesDict.Add(ResourceName, ResourceFullName);

                    if ResourceList <> '' then
                        ResourceList += ', ';
                    ResourceList += ResourceFullName;
                end;
            until JobPlanningLine.Next() = 0;

        exit(ResourceList);
    end;

    procedure RefreshGantt()
    var
        GanttData: JsonObject;
        ResourcesArray: JsonArray;
    begin
        // Récupérer les données du diagramme Gantt (tâches)
        GanttData := JobAsJson();

        // Récupérer les données des ressources directement comme tableau
        ResourcesArray := ResourceAsJson();

        // Ajouter les ressources au JSON du diagramme Gantt
        GanttData.Add('resources', ResourcesArray);

        // Charger les données complètes dans le diagramme Gantt
        CurrPage.Gantt.Load(GanttData);
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

    procedure UpdateJobTask(taskData: JsonObject)
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        EarliestPlanningLine: Record "Job Planning Line";
        LatestPlanningLine: Record "Job Planning Line";
        JobNo: Text;
        JobTaskNo: Text;
        Description: Text;
        StartDate: Date;
        Duration: Integer;
        JsonToken: JsonToken;
        DateText: Text;
        EarliestDate: Date;
        LatestDate: Date;
        NewEndDate: Date;
        EarliestLineNo: Integer;
        LatestLineNo: Integer;
        HasUpdatedDates: Boolean;

    begin
        HasUpdatedDates := false;

        // Extract basic task data
        // Try to get job_no, fallback to current Job record
        if taskData.Get('job_no', JsonToken) then
            JobNo := JsonToken.AsValue().AsText()
        else begin
            JobTask.Get(Rec."No.", ''); // Get Job No. from current record
            JobNo := JobTask."Job No.";
        end;

        if not taskData.Get('job_task_no', JsonToken) then
            Error('Job Task No. not found in task data.');
        JobTaskNo := JsonToken.AsValue().AsText();

        if not taskData.Get('text', JsonToken) then
            Error('Description not found in task data.');
        Description := JsonToken.AsValue().AsText();

        // Find the task
        if not JobTask.Get(JobNo, JobTaskNo) then
            Error('Job Task not found: %1 %2', JobNo, JobTaskNo);

        // Update description
        JobTask.Description := CopyStr(Description, 1, MaxStrLen(JobTask.Description));
        JobTask.Modify(true);

        // Vérifier si nous avons une nouvelle date de début ou une durée à traiter
        if (taskData.Get('start_date', JsonToken) and (not JsonToken.AsValue().IsNull())) or
           (taskData.Get('duration', JsonToken) and (not JsonToken.AsValue().IsNull())) then begin
            // Rechercher les lignes de planification associées à cette tâche
            JobPlanningLine.Reset();
            JobPlanningLine.SetRange("Job No.", JobNo);
            JobPlanningLine.SetRange("Job Task No.", JobTaskNo);

            if not JobPlanningLine.FindSet() then
                exit; // Pas de lignes de planification à modifier

            // Identifier la ligne avec la date la plus ancienne et la plus récente
            EarliestDate := 0D;
            LatestDate := 0D;
            EarliestLineNo := 0;
            LatestLineNo := 0;

            repeat
                if (EarliestDate = 0D) or (JobPlanningLine."Planning Date" < EarliestDate) then begin
                    EarliestDate := JobPlanningLine."Planning Date";
                    EarliestLineNo := JobPlanningLine."Line No.";
                end;

                if (JobPlanningLine."Planning Date" > LatestDate) then begin
                    LatestDate := JobPlanningLine."Planning Date";
                    LatestLineNo := JobPlanningLine."Line No.";
                end;
            until JobPlanningLine.Next() = 0;

            // Traiter la nouvelle date de début si spécifiée
            if taskData.Get('start_date', JsonToken) and (not JsonToken.AsValue().IsNull()) then begin
                DateText := JsonToken.AsValue().AsText();
                if DateText <> '' then begin
                    // Convert to Date using ISO format (YYYY-MM-DD)
                    if not Evaluate(StartDate, DateText, 9) then // 9 = YYYY-MM-DD format
                        Error('Invalid date format: %1. Please use YYYY-MM-DD format.', DateText);

                    // Mettre à jour uniquement la ligne ayant la date la plus ancienne
                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", JobNo);
                    JobPlanningLine.SetRange("Job Task No.", JobTaskNo);
                    JobPlanningLine.SetRange("Line No.", EarliestLineNo);

                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine."Planning Date" := StartDate;
                        JobPlanningLine."Planned Delivery Date" := StartDate;
                        JobPlanningLine.Modify(true);
                        HasUpdatedDates := true;
                    end;
                end;
            end;

            // Traiter la durée si spécifiée
            if taskData.Get('duration', JsonToken) and (not JsonToken.AsValue().IsNull()) then begin
                Duration := JsonToken.AsValue().AsInteger();
                if Duration > 0 then begin
                    // Obtenir la nouvelle date de début
                    if taskData.Get('start_date', JsonToken) and (not JsonToken.AsValue().IsNull()) then begin
                        DateText := JsonToken.AsValue().AsText();
                        if not Evaluate(StartDate, DateText, 9) then
                            StartDate := EarliestDate;
                    end
                    else
                        StartDate := EarliestDate;

                    // Calculer la nouvelle date de fin basée sur la durée
                    NewEndDate := StartDate + Duration - 1;

                    // Mettre à jour uniquement la ligne ayant la date la plus récente
                    JobPlanningLine.Reset();
                    JobPlanningLine.SetRange("Job No.", JobNo);
                    JobPlanningLine.SetRange("Job Task No.", JobTaskNo);
                    JobPlanningLine.SetRange("Line No.", LatestLineNo);

                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine."Planning Date" := NewEndDate;
                        JobPlanningLine."Planned Delivery Date" := NewEndDate;
                        JobPlanningLine.Modify(true);
                        HasUpdatedDates := true;
                    end;
                end;
            end;

            // Recalculer les FlowFields après mise à jour des lignes de planification
            JobTask.CalcFields("Start Date", "End Date");
        end;

        // Un seul message à la fin de la procédure
        if HasUpdatedDates then
            Message('Task %1 updated with Start Date: %2, End Date: %3',
                   JobTaskNo, Format(JobTask."Start Date"), Format(JobTask."End Date"))
        else
            Message('Task %1 description updated.', JobTaskNo);
    end;

    procedure GetResourceTasks(ResourceNo: Code[20]): Integer
    var
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        TasksDict: Dictionary of [Text, Boolean];
        TaskKey: Text;
        TaskCount: Integer;
    begin
        Clear(TasksDict);
        TaskCount := 0;

        // Rechercher toutes les lignes de planification pour cette ressource
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetRange("No.", ResourceNo);

        if JobPlanningLine.FindSet() then
            repeat
                // Créer une clé unique pour chaque tâche (Job No. + Job Task No.)
                TaskKey := StrSubstNo('%1|%2', JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");

                // Vérifier si cette tâche existe et n'a pas déjà été comptée
                if not TasksDict.ContainsKey(TaskKey) then begin
                    // Vérifier que la tâche existe réellement dans la table Job Task
                    if JobTask.Get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.") then begin
                        TasksDict.Add(TaskKey, true);
                        TaskCount += 1;
                    end;
                end;
            until JobPlanningLine.Next() = 0;

        exit(TaskCount);
    end;


    procedure GetResourceTotalWorkload(ResourceNo: Code[20]): Decimal
    var
        JobPlanningLine: Record "Job Planning Line";
        TotalWorkload: Decimal;
    begin
        TotalWorkload := 0;

        // Rechercher toutes les lignes de planification pour cette ressource
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetRange("No.", ResourceNo);

        if JobPlanningLine.FindSet() then
            repeat
                // Additionner toutes les quantités planifiées
                TotalWorkload += JobPlanningLine.Quantity;
            until JobPlanningLine.Next() = 0;

        exit(TotalWorkload);
    end;


    // Version optimisée de ResourceAsJson avec GetResourcePlanningData intégré
    procedure ResourceAsJson(): JsonArray
    var
        ResourceRec: Record Resource;
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        resources: JsonArray;
        resource: JsonObject;
        planningArray: JsonArray;
        planningObject: JsonObject;
        resourceId: Integer;
        taskCount: Integer;
        totalWorkload: Decimal;
        DateQuantityMap: Dictionary of [Text, Decimal];
        TasksDict: Dictionary of [Text, Boolean];
        DateKey: Text;
        TaskKey: Text;
        Quantity: Decimal;
        Keys: List of [Text];
        i: Integer;
    begin
        Clear(resources);
        resourceId := 0;

        if ResourceRec.FindSet() then
            repeat
                resourceId += 1;
                Clear(resource);
                Clear(DateQuantityMap);
                Clear(TasksDict);
                Clear(planningArray);
                taskCount := 0;
                totalWorkload := 0;

                // Parcourir toutes les lignes de planification pour cette ressource
                JobPlanningLine.Reset();
                JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
                JobPlanningLine.SetRange("No.", ResourceRec."No.");

                if JobPlanningLine.FindSet() then
                    repeat
                        // 1. Calculer le nombre de tâches uniques
                        TaskKey := StrSubstNo('%1|%2', JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
                        if not TasksDict.ContainsKey(TaskKey) then begin
                            // Vérifier que la tâche existe réellement
                            if JobTask.Get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.") then begin
                                TasksDict.Add(TaskKey, true);
                                taskCount += 1;
                            end;
                        end;

                        // 2. Calculer le workload total
                        totalWorkload += JobPlanningLine.Quantity;

                        // 3. Accumuler les quantités par date pour les données de planification
                        DateKey := Format(JobPlanningLine."Planning Date", 0, 9); // Format YYYY-MM-DD
                        if DateQuantityMap.ContainsKey(DateKey) then begin
                            DateQuantityMap.Get(DateKey, Quantity);
                            DateQuantityMap.Set(DateKey, Quantity + JobPlanningLine.Quantity);
                        end else
                            DateQuantityMap.Add(DateKey, JobPlanningLine.Quantity);

                    until JobPlanningLine.Next() = 0;

                // Convertir les données de planification en tableau JSON
                Keys := DateQuantityMap.Keys();
                for i := 1 to Keys.Count() do begin
                    DateKey := Keys.Get(i);
                    DateQuantityMap.Get(DateKey, Quantity);

                    Clear(planningObject);
                    planningObject.Add('date', DateKey);
                    planningObject.Add('quantity', Quantity);
                    planningObject.Add('resource_no', ResourceRec."No.");

                    planningArray.Add(planningObject);
                end;

                // Construire l'objet ressource final
                resource.Add('id', resourceId);
                resource.Add('resource_no', ResourceRec."No.");
                resource.Add('name', ResourceRec.Name);
                resource.Add('type', Format(ResourceRec.Type));
                resource.Add('base_unit_of_measure', ResourceRec."Base Unit of Measure");
                resource.Add('direct_unit_cost', ResourceRec."Direct Unit Cost");
                resource.Add('assignment', taskCount);
                resource.Add('task_count', taskCount);
                resource.Add('total_workload', totalWorkload);
                resource.Add('planning_dates', planningArray);
                // Ajout du champ Job Title
                resource.Add('job_title', ResourceRec."Job Title");
                if ResourceRec."Resource Group No." <> '' then
                    resource.Add('resource_group', ResourceRec."Resource Group No.")
                else
                    resource.Add('resource_group', '');

                resources.Add(resource);
            until ResourceRec.Next() = 0;

        exit(resources);
    end;
    // Ajouter cette procédure à la fin de la page, avant la dernière accolade
    procedure DeleteLink(SourceTaskNo: Text; TargetTaskNo: Text)
    var
        JobTaskDependency: Record "Job Task Dependency";
        JobTask: Record "Job Task";
        JobNo: Code[20];
        SourceTaskDesc: Text;
        TargetTaskDesc: Text;
        SuccessMsg: Label 'Dependency between "%1" (%2) and "%3" (%4) has been successfully deleted.';
        NotFoundErr: Label 'Dependency between "%1" (%2) and "%3" (%4) not found.';
        DependencyFound: Boolean;
    begin
        DependencyFound := false;

        // Find Job No. and task descriptions
        JobTask.Reset();
        JobTask.SetRange("Job Task No.", SourceTaskNo);
        if JobTask.FindFirst() then begin
            JobNo := JobTask."Job No.";
            SourceTaskDesc := JobTask.Description;

            // Find target task description
            JobTask.Reset();
            JobTask.SetRange("Job Task No.", TargetTaskNo);
            if JobTask.FindFirst() then
                TargetTaskDesc := JobTask.Description
            else
                TargetTaskDesc := TargetTaskNo;

            // Find the dependency
            JobTaskDependency.Reset();
            JobTaskDependency.SetRange("Job No.", JobNo);
            JobTaskDependency.SetRange("Predecessor Job Task No.", SourceTaskNo);
            JobTaskDependency.SetRange("Job Task No.", TargetTaskNo);

            if JobTaskDependency.FindFirst() then begin
                DependencyFound := true;
                // Delete the dependency directly
                JobTaskDependency.Delete(true);
                Message(StrSubstNo(SuccessMsg, SourceTaskNo, SourceTaskDesc, TargetTaskNo, TargetTaskDesc));
            end;
        end;

        if not DependencyFound then
            Error(StrSubstNo(NotFoundErr, SourceTaskNo, SourceTaskDesc, TargetTaskNo, TargetTaskDesc));
    end;
    /////////////////
    // Procédure pour créer un lien entre deux tâches
// Procédure améliorée pour créer un lien entre deux tâches
procedure CreateLink(SourceTaskNo: Text; TargetTaskNo: Text; LinkType: Text)
var
    JobTaskDependency: Record "Job Task Dependency";
    JobTask: Record "Job Task";
    SourceJobRec: Record "Job Task";
    TargetJobRec: Record "Job Task";
    JobNo: Code[20];
    SourceTaskDesc: Text;
    TargetTaskDesc: Text;
    DependencyType: Enum "Job Task Dependency Type";
    SuccessMsg: Label 'Dependency created between "%1" (%2) and "%3" (%4) with type: %5';
    NotFoundErr: Label 'Task "%1" not found.';
    AlreadyExistsErr: Label 'Dependency between "%1" and "%2" already exists.';
    SelfDependencyErr: Label 'Cannot create dependency: a task cannot depend on itself.';
    CircularDependencyErr: Label 'Cannot create dependency: this would create a circular dependency.';
    DifferentProjectErr: Label 'Cannot create dependency: tasks belong to different projects.';
    TaskFound: Boolean;
    SourceJobNo: Code[20];
    TargetJobNo: Code[20];
begin
    // Validation initiale
    if (SourceTaskNo = '') or (TargetTaskNo = '') then
        Error('Source and target task numbers cannot be empty.');
    
    // Vérifier que les tâches ne sont pas identiques
    if SourceTaskNo = TargetTaskNo then
        Error(SelfDependencyErr);

    // Trouver la tâche source
    Clear(SourceJobRec);
    TaskFound := false;
    SourceJobRec.Reset();
    SourceJobRec.SetRange("Job Task No.", SourceTaskNo);
    if SourceJobRec.FindSet() then
        repeat
            TaskFound := true;
            SourceJobNo := SourceJobRec."Job No.";
            SourceTaskDesc := SourceJobRec.Description;
        until SourceJobRec.Next() = 0;
    
    if not TaskFound then
        Error(StrSubstNo(NotFoundErr, SourceTaskNo));
    
    // Trouver la tâche cible
    Clear(TargetJobRec);
    TaskFound := false;
    TargetJobRec.Reset();
    TargetJobRec.SetRange("Job Task No.", TargetTaskNo);
    if TargetJobRec.FindSet() then
        repeat
            if TargetJobRec."Job No." = SourceJobNo then begin
                TaskFound := true;
                TargetJobNo := TargetJobRec."Job No.";
                TargetTaskDesc := TargetJobRec.Description;
            end;
        until (TargetJobRec.Next() = 0) or TaskFound;
    
    if not TaskFound then
        Error(StrSubstNo(NotFoundErr, TargetTaskNo));
    
    // Vérifier que les tâches appartiennent au même projet
    if SourceJobNo <> TargetJobNo then
        Error(DifferentProjectErr);
    
    JobNo := SourceJobNo;
    
    // Vérifier si la dépendance existe déjà
    JobTaskDependency.Reset();
    JobTaskDependency.SetRange("Job No.", JobNo);
    JobTaskDependency.SetRange("Predecessor Job Task No.", SourceTaskNo);
    JobTaskDependency.SetRange("Job Task No.", TargetTaskNo);
    if JobTaskDependency.FindFirst() then
        Error(StrSubstNo(AlreadyExistsErr, SourceTaskNo, TargetTaskNo));
    
    // Vérifier les dépendances circulaires
    if CheckCircularDependency(JobNo, SourceTaskNo, TargetTaskNo) then
        Error(CircularDependencyErr);
    
    // Déterminer le type de dépendance avec validation
    case LinkType of
        '0': DependencyType := DependencyType::"Finish-to-Start";
        '1': DependencyType := DependencyType::"Start-to-Start";
        '2': DependencyType := DependencyType::"Finish-to-Finish";
        '3': DependencyType := DependencyType::"Start-to-Finish";
        else begin
            DependencyType := DependencyType::"Finish-to-Start";
            Message('Invalid link type "%1", defaulting to Finish-to-Start', LinkType);
        end;
    end;
    
    // Créer la nouvelle dépendance avec gestion d'erreur
    JobTaskDependency.Init();
    JobTaskDependency."Job No." := JobNo;
    JobTaskDependency."Job Task No." := TargetTaskNo;
    JobTaskDependency."Predecessor Job Task No." := SourceTaskNo;
    JobTaskDependency."Dependency Type" := DependencyType;
    
    if JobTaskDependency.Insert(true) then
        Message(StrSubstNo(SuccessMsg, SourceTaskNo, SourceTaskDesc, TargetTaskNo, TargetTaskDesc, Format(DependencyType)))
    else
        Error('Failed to create dependency between %1 and %2', SourceTaskNo, TargetTaskNo);
end;

// Procédure améliorée pour vérifier les dépendances circulaires
procedure CheckCircularDependency(JobNo: Code[20]; SourceTaskNo: Text; TargetTaskNo: Text): Boolean
var
    VisitedTasks: Dictionary of [Text, Boolean];
    StackTasks: Dictionary of [Text, Boolean];
begin
    // Initialiser les dictionnaires
    Clear(VisitedTasks);
    Clear(StackTasks);
    
    // Vérifier s'il y a un chemin de TargetTaskNo vers SourceTaskNo (DFS avec détection de cycle)
    exit(HasCyclicPath(JobNo, TargetTaskNo, SourceTaskNo, VisitedTasks, StackTasks));
end;

// Procédure améliorée avec détection de cycle utilisant DFS
procedure HasCyclicPath(JobNo: Code[20]; CurrentTask: Text; TargetTask: Text; var VisitedTasks: Dictionary of [Text, Boolean]; var StackTasks: Dictionary of [Text, Boolean]): Boolean
var
    JobTaskDependency: Record "Job Task Dependency";
begin
    // Si la tâche est déjà dans la pile de récursion, nous avons un cycle
    if StackTasks.ContainsKey(CurrentTask) then
        exit(true);
    
    // Si nous avons déjà visité cette tâche et qu'elle n'est pas dans la pile, pas de cycle par ce chemin
    if VisitedTasks.ContainsKey(CurrentTask) then
        exit(false);
    
    // Marquer la tâche comme visitée et l'ajouter à la pile
    VisitedTasks.Add(CurrentTask, true);
    StackTasks.Add(CurrentTask, true);
    
    // Si nous avons trouvé la tâche cible, il y aurait un cycle
    if CurrentTask = TargetTask then begin
        StackTasks.Remove(CurrentTask);
        exit(true);
    end;
    
    // Chercher tous les successeurs de CurrentTask
    JobTaskDependency.Reset();
    JobTaskDependency.SetRange("Job No.", JobNo);
    JobTaskDependency.SetRange("Predecessor Job Task No.", CurrentTask);
    
    if JobTaskDependency.FindSet() then
        repeat
            // Récursivement vérifier chaque successeur
            if HasCyclicPath(JobNo, JobTaskDependency."Job Task No.", TargetTask, VisitedTasks, StackTasks) then begin
                StackTasks.Remove(CurrentTask);
                exit(true);
            end;
        until JobTaskDependency.Next() = 0;
    
    // Retirer la tâche de la pile avant de retourner
    StackTasks.Remove(CurrentTask);
    exit(false);
end;
}