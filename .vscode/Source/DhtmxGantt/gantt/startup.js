//startup.js
// == Configuration de base ==
gantt.config.date_format = "%Y-%m-%d %H:%i";

gantt.config.columns = [
    { name: "text", label: "Task name", width: "*", tree: true },
    { name: "start_date", label: "Start", align: "center" },
    // { name: "end_date", label: "End", align: "center" }, // Décommenter si nécessaire
    { name: "duration", label: "Duration", align: "center" },
    {
        name: "add", label: "+", width: 40, align: "center",
        template: function (task) {
            return "<button class='add-subtask' data-task-id='" + task.id + "'>+</button>";
        }
    }
];

// == Création du conteneur principal ==
const container = document.getElementById("controlAddIn");
const ganttDiv = document.createElement("div");
ganttDiv.id = "gantt_here";
ganttDiv.style.width = "100%";
ganttDiv.style.height = "90%";
container.appendChild(ganttDiv);

// == Templates Week-end ==
gantt.templates.scale_cell_class = function(date) {
    return (date.getDay() === 0 || date.getDay() === 6) ? "weekend" : "";
};
gantt.templates.task_cell_class = function(item, date) {
    return (date.getDay() === 0 || date.getDay() === 6) ? "weekend" : "";
};

// == Styles personnalisés ==
const style = document.createElement('style');
style.innerHTML = `
    .gantt_task_row {
        background-color: #f0f0f0;
    }
    .gantt_task_content {
        background-color: rgb(76, 162, 175);
        border-radius: 5px;
        color: white;
    }
    .gantt_grid_data {
        font-family: 'Segoe UI', sans-serif;
        font-size: 14px;
    }
`;
document.head.appendChild(style);

// == Zoom Control ==
initZoomControl(gantt);

// == Configuration du Gantt ==
gantt.config.auto_scheduling = true;
gantt.config.auto_scheduling_strict = true; // Recommande fortement pour que les dates parentales se basent sur les enfants
gantt.config.update_rendered = true;
gantt.config.smart_rendering = false;
gantt.config.order_branch = true;
gantt.config.order_branch_free = true;

// == Mise à jour automatique des tâches parentes ==
function updateParent(taskId) {
    const task = gantt.getTask(taskId);
    if (task.parent) {
        gantt.updateTask(task.parent);
    }
}

gantt.attachEvent("onAfterTaskUpdate", function(id) {
    updateParent(id);
});
gantt.attachEvent("onAfterTaskAdd", function(id, task) {
    updateParent(id);
});
gantt.attachEvent("onAfterTaskDelete", function(id, task) {
    if (task && task.parent) {
        gantt.updateTask(task.parent);
    }
});

// == Initialisation ==
gantt.init("gantt_here");

// == Forcer la mise à jour de toutes les tâches parentes après chargement ==
gantt.eachTask(function(task){
    if (task.parent) {
        gantt.updateTask(task.parent);
    }
});

// == Notifier NAV que le Gantt est prêt ==
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlReady", []);
