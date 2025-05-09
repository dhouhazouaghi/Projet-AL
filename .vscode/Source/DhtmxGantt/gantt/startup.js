// == Configuration de base ==
gantt.config.date_format = "%Y-%m-%d %H:%i";

gantt.config.columns = [
    { name: "text", label: "Task name", width: "*", tree: true },
    { name: "start_date", label: "Start", align: "center" },
    { name: "duration", label: "Duration", align: "center" },
    {
        name: "add", label: "+", width: 40, align: "center",
        template: function (task) {
            return "<button class='add-subtask' data-task-id='" + task.id + "'>+</button>";
        }
    }
];
gantt.config.drag_move = true;
gantt.config.drag_links = true;
gantt.config.enable_inline_editing = true;
// == Custom milestone rendering ==
gantt.templates.task_class = function(start, end, task) {
    if (task.type === "milestone") {
        return "gantt-milestone";
    }
    return "";
};

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
  
   
    .gantt_grid_data {
        font-family: 'Segoe UI', sans-serif;
        font-size: 14px;
    }
    .gantt_grid {
        background-color: #f9f9f9;
    }
    .gantt_task_row {
        background-color: #f0f8ff;
    }
    .gantt_task_content {
        border-radius: 6px;
        background-color: #5a9bd5;
        color: white;
    }
    .gantt_scale_cell.weekend,
    .gantt_task_cell.weekend {
        background-color: #fce4e4;
    }
    .gantt-milestone .gantt_task_content {
        width: 14px !important;
        height: 14px !important;
        background-color: #ff4d4d !important;
        transform: rotate(45deg);
        position: absolute;
        top: 50%;
        left: 50%;
        margin: -7px 0 0 -7px;
        border-radius: 2px;
        border: 1px solid #333;
        color: transparent !important; /* Hide text inside milestone */
    }
    .gantt-milestone .gantt_task_line {
        display: none;
    }
`;
document.head.appendChild(style);
// gantt.templates.rightside_text = function (start, end, task) {
// 		if (task.type == gantt.config.types.milestone) {
// 			return task.text;
// 		}
// 		return "";
// 	};
// == Zoom Control ==
initZoomControl(gantt);

// == Configuration du Gantt ==
gantt.config.auto_scheduling = true;
gantt.config.auto_scheduling_strict = true;
gantt.config.update_rendered = true;
gantt.config.smart_rendering = false;
gantt.config.order_branch = true;
gantt.config.order_branch_free = true;
gantt.config.show_links = true;
gantt.config.link_attribute = "type";

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
// Événement : Suppression d'une tâche
gantt.attachEvent("onAfterTaskDelete", function(id) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnTaskDelete", [id.toString()]);
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