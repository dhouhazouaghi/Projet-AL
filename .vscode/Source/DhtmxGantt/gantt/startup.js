// Configuration des formats et options de base
gantt.config.date_format = "%Y-%m-%d";
gantt.config.drag_resize = true;
gantt.config.grid_resize = true;
gantt.config.columns_resize = true;
gantt.config.drag_move = true;
gantt.config.enable_inline_editing = true;
gantt.config.bar_height = 22;
gantt.config.update_rendered = true;
gantt.config.smart_rendering = false;
gantt.config.order_branch = true;
gantt.config.order_branch_free = true;
gantt.config.show_links = true;
gantt.config.link_attribute = "type";
gantt.config.drag_links = true;
// Configuration spécifique pour les ressources
gantt.config.resource_store = "resource";
gantt.config.resource_property = "owner_id";
gantt.config.process_resource_assignments = true;
gantt.config.resource_render_empty_cells = true;
gantt.config.types.milestone = "milestone";
gantt.config.tooltip_offset_x = 15;
gantt.config.tooltip_offset_y = 20;
gantt.config.tooltip_timeout = 500; 
// Configuration des types de tâches 
gantt.config.types = {
    task: "task",
    project: "project", 
    milestone: "milestone"
};
// ACTIVATION DES PLUGINS
gantt.plugins({ 
    tooltip: true,
    marker: true,
    fullscreen: true
});
var dateToStr = gantt.date.date_to_str(gantt.config.task_date);
var today = new Date(); // Date actuelle
gantt.addMarker({
    start_date: today,
    css: "today",
    text: "Today",
    title: "Today: " + dateToStr(today)
});
gantt.templates.tooltip_text = function(start, end, task) {
    // Formatage des dates
    const start_date = gantt.date.date_to_str("%d-%m-%Y")(task.start_date);
    const end_date = gantt.date.date_to_str("%d-%m-%Y")(task.end_date);
    
    // Construction du contenu HTML du tooltip
    return `
        <div class="tooltip-header">
            <b>${task.text}</b>
        </div>
        <div class="tooltip-content">
            <div><b>Start:</b> ${start_date}</div>
            <div><b>End:</b> ${end_date}</div>
            <div><b>Duration:</b> ${task.duration} day(s)</div>
            ${task.owner ? `<div><b>Owner:</b> ${task.owner}</div>` : ''}
            ${task.progress ? `<div><b>Progress:</b> ${task.progress}%</div>` : ''}
            ${task.parent ? `<div><b>Parent Task:</b> ${gantt.getTask(task.parent).text || ''}</div>` : ''}
        </div>
    `;
};

// =============================================
// CONFIGURATION FULLSCREEN CORRIGÉE
// =============================================

// Fonction pour créer le bouton fullscreen
function createFullscreenButton() {
    // Supprimer l'ancien bouton s'il existe
    const existingButton = document.querySelector('.gantt-fullscreen-btn');
    if (existingButton) {
        existingButton.remove();
    }
    
    // Créer le nouveau bouton
    const fullscreenBtn = document.createElement("button");
    fullscreenBtn.className = "gantt-fullscreen-btn";
    fullscreenBtn.innerHTML = `
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>
        </svg>
        <span class="btn-text">Fullscreen</span>
    `;
    
    // Événement click pour le bouton
    fullscreenBtn.onclick = function() {
        if (gantt.ext && gantt.ext.fullscreen) {
            gantt.ext.fullscreen.toggle();
        }
    };
    
    // Ajouter le bouton au conteneur gantt
    const ganttContainer = gantt.$container;
    if (ganttContainer) {
        ganttContainer.appendChild(fullscreenBtn);
    }
    
    return fullscreenBtn;
}

// Événements fullscreen
gantt.attachEvent("onGanttReady", function() {
    createFullscreenButton();
});

gantt.attachEvent("onExpand", function () {
    const btn = document.querySelector('.gantt-fullscreen-btn');
    if (btn) {
        btn.innerHTML = `
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M8 3v3a2 2 0 0 1-2 2H3m18 0h-3a2 2 0 0 1-2-2V3m0 18v-3a2 2 0 0 1 2-2h3M3 16h3a2 2 0 0 1 2 2v3"/>
            </svg>
            <span class="btn-text">Exit Fullscreen</span>
        `;
        btn.classList.add('fullscreen-active');
    }
});

gantt.attachEvent("onCollapse", function () {
    const btn = document.querySelector('.gantt-fullscreen-btn');
    if (btn) {
        btn.innerHTML = `
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"/>
            </svg>
            <span class="btn-text">Fullscreen</span>
        `;
        btn.classList.remove('fullscreen-active');
    }
});
// =============================================
// CONFIGURATION DES COLONNES
// =============================================
gantt.templates.rightside_text = function (start, end, task) {
		if (task.type == gantt.config.types.milestone) {
			return task.text;
		}
		return "";
	};


let resourcesData = [];
gantt.config.columns = [
    { 
        name: "text", 
        label: "Task name", 
        width: "*", 
        tree: true, 
        resize: true
    },
    { 
        name: "start_date", 
        label: "Start", 
        align: "center", 
        resize: true 
    },
    { 
        name: "duration", 
        label: "Duration", 
        align: "center", 
        resize: true 
    },
    { 
        name: "owner", 
        label: "Owner", 
        align: "center", 
        width: 100, 
        resize: true,
        template: function(obj) {
            // Pour les projets
             if (obj.type == gantt.config.types.project) {
                if (obj.owner && obj.owner.trim() !== "") {
                    return `<span class='project-responsible' title='Person Responsible: ${obj.owner}'>${obj.owner}</span>`;
                } else {
                    return "<span class='no-responsible'>No Person Responsible</span>";
                }
            }
            
            // Pour les tâches sans assignation
            if (!obj.owner || obj.owner.trim() === "") {
                return "<span class='unassigned-label'>Unassigned</span>";
            }
            
            // Séparer les propriétaires (s'ils sont multiples)
            const owners = obj.owner.split(',');
            
            // Pour une seule assignation
            if (owners.length === 1) {
                return owners[0].trim();
            }
            
            // Pour plusieurs assignations
            let html = "";
            owners.forEach(owner => {
                const trimmedOwner = owner.trim();
                if (trimmedOwner) {
                    const initial = trimmedOwner.substr(0, 1).toUpperCase();
                    html += `<div class='owner-initial' title='${trimmedOwner}'>${initial}</div>`;
                }
            });
            return html;
        }
    },
    {
        name: "add", 
        label: "+", 
        width: 40, 
        align: "center",
        template: function (task) {
            return "<button class='add-subtask' data-task-id='" + task.id + "'>+</button>";
        }
    }
];

// =============================================
// CONFIGURATION DES TYPES DE TÂCHES
// =============================================

gantt.serverList("job_task_types", [
    { key: "Posting", label: "Posting" },
    { key: "Heading", label: "Heading" },
    { key: "Total", label: "Total" }
]);

// =============================================
// CONFIGURATION DE LA LIGHTBOX
// =============================================

gantt.locale.labels.section_resources = "Owners";

gantt.config.lightbox.sections = [
    { 
        name: "description", 
        height: 38, 
        map_to: "text", 
        type: "textarea", 
        focus: true 
    },
    { 
        name: "job_task_type", 
        height: 22, 
        map_to: "task_type", 
        type: "select", 
        options: gantt.serverList("job_task_types")
    },
    {
        name: "resources", 
        type: "resources", 
        map_to: "owner_id", 
        options: null,
        height: 60
    },
    { 
        name: "time", 
        height: 72, 
        map_to: "auto", 
        type: "duration",
        time_format: ["%d", "%m", "%Y"] 
    }
];

// =============================================
// CONFIGURATION DU LAYOUT AVEC RESSOURCES
// =============================================

gantt.config.layout = {
    css: "gantt_container",
    rows: [
        {
            cols: [
                { view: "grid", group: "grids", scrollY: "scrollVer" },
                { resizer: true, width: 1 },
                { view: "timeline", scrollX: "scrollHor", scrollY: "scrollVer" },
                { view: "scrollbar", id: "scrollVer", group: "vertical" }
            ],
            gravity: 2
        },
        { resizer: true, width: 1 },
        {
            config: {
                columns: [
                    
                    {
                        name: "name", 
                        label: "Resource", 
                        tree: true, 
                        width: 200, 
                        resize: true,
                       template: function(resource) {
    return (resource.text || resource.name || "Resource") + ', <span class="badge">' + resource.job_title + '</span>';
}
                    },
                    {
                        name: "assignment", 
                        label: "Assignment", 
                        width: 80,
                        resize: true,
                        template: function(resource) {
                            return (resource.assignment || 0) + ' task(s)';
                        }
                    },
                    {
                        name: "workload", 
                        label: "Workload", 
                        width: 80,
                        resize: true,
                        template: function(resource) {
                            return (resource.total_workload || 0) + ' ' + (resource.base_unit_of_measure || '');
                        }
                    }
                ]
            },
            cols: [
                { view: "resourceGrid", group: "grids", width: 280, scrollY: "resourceVScroll" },
                { resizer: true, width: 1 },
                { view: "resourceTimeline", scrollX: "scrollHor", scrollY: "resourceVScroll" },
                { view: "scrollbar", id: "resourceVScroll", group: "vertical" }
            ],
            gravity: 1
        },
        { view: "scrollbar", id: "scrollHor" }
    ]
};

// =============================================
// TEMPLATES ET STYLES PERSONNALISÉS
// =============================================

// Template pour les classes de tâches
gantt.templates.task_class = function(start, end, task) {
    var classes = [];
    
    if (task.type === "milestone") {
        classes.push("gantt-milestone");
    }
    
    // Si la tâche a un parent = 0, c'est un projet
    if (task.parent == 0) {
        classes.push("gantt-project");
    }
    
    return classes.join(" ");
};

// Templates pour les week-ends
gantt.templates.scale_cell_class = function(date) {
    return (date.getDay() === 0 || date.getDay() === 6) ? "weekend" : "";
};

gantt.templates.timeline_cell_class = function(item, date) {
    return (date.getDay() === 0 || date.getDay() === 6) ? "weekend" : "";
};

// Templates pour les ressources
gantt.templates.resource_cell_class = function(start_date, end_date, resource, tasks) {
    const css = ["resource_marker"];
    
    if (!resource || !resource.planning_dates || !Array.isArray(resource.planning_dates)) {
        return css.join(" ");
    }
    
    // Convertir la date pour comparaison
    const cellDate = gantt.date.date_to_str("%Y-%m-%d")(start_date);
    
    // Chercher la quantité pour cette date
    const planningForDate = resource.planning_dates.find(planning => {
        return planning.date === cellDate;
    });
    
    if (planningForDate && planningForDate.quantity > 0) {
        const quantity = planningForDate.quantity;
        
        // Définir des seuils pour les couleurs (à ajuster selon vos besoins)
        if (quantity <= 8) {
            css.push("workday_ok");
        } else if (quantity <= 12) {
            css.push("workday_warning");
        } else {
            css.push("workday_over");
        }
    }
    
    return css.join(" ");
};

gantt.templates.resource_cell_value = function(start_date, end_date, resource, tasks) {
    if (!resource || !resource.planning_dates || !Array.isArray(resource.planning_dates)) {
        return "";
    }
    
    // Convertir la date de début en format string pour comparaison
    const cellDate = gantt.date.date_to_str("%Y-%m-%d")(start_date);
    
    // Chercher la quantité planifiée pour cette date spécifique
    const planningForDate = resource.planning_dates.find(planning => {
        return planning.date === cellDate;
    });
    
    if (planningForDate && planningForDate.quantity > 0) {
        const quantity = Math.round(planningForDate.quantity * 100) / 100; // Arrondir à 2 décimales
        const unit = resource.base_unit_of_measure || 'h';
        
        return `<div class='resource-quantity' title='${resource.name}: ${quantity} ${unit} on ${cellDate}'>${quantity}</div>`;
    }
    
    return "";
};
// == 9. FONCTION DE MISE À JOUR DYNAMIQUE DES DONNÉES DE PLANIFICATION ==
function updateResourcePlanningData(resourceNo, planningData) {
    const resource = resourcesData.find(r => r.resource_no === resourceNo);
    if (resource) {
        resource.planning_dates = planningData.map(planning => ({
            date: planning.date,
            quantity: parseFloat(planning.quantity) || 0,
            resource_no: planning.resource_no
        }));
        
        gantt.updateCollection("resource", resourcesData);
        gantt.render();
        
        console.log(`Updated planning data for resource ${resourceNo}:`, resource.planning_dates);
    } else {
        console.warn(`Resource ${resourceNo} not found for planning update`);
    }
}
// =============================================
// CRÉATION DU DOM ET STYLES CSS
// =============================================

// Création du conteneur principal
const container = document.getElementById("controlAddIn");
const ganttDiv = document.createElement("div");
ganttDiv.id = "gantt_here";
ganttDiv.style.width = "100%";
ganttDiv.style.height = "100%";
container.appendChild(ganttDiv);

// =============================================
// FONCTIONS UTILITAIRES
// =============================================

// Fonction de chargement des ressources
function loadResourcesData(resources) {
    if (!resources || !Array.isArray(resources)) {
        console.log("No resources data provided");
        return;
    }
 
    resourcesData = resources.map((resource, index) => {
        // Traitement des planning_dates pour s'assurer du bon format
        let planningDates = [];
        if (resource.planning_dates && Array.isArray(resource.planning_dates)) {
            planningDates = resource.planning_dates.map(planning => ({
                date: planning.date,
                quantity: parseFloat(planning.quantity) || 0,
                resource_no: planning.resource_no
            }));
        }

        return {
            id: resource.id || resource.resource_no || (index + 1),
            text: resource.name || resource.resource_no || `Resource ${index + 1}`,
            name: resource.name || resource.resource_no,
            resource_no: resource.resource_no,
            type: resource.type,
            base_unit_of_measure: resource.base_unit_of_measure || 'h',
            direct_unit_cost: resource.direct_unit_cost || 0,
            resource_group: resource.resource_group || '',
            assignment: resource.assignment || resource.task_count || 0,
            total_workload: resource.total_workload || 0,
            planning_dates: planningDates
        };
    });
 
    // Mise à jour de la collection des ressources
    gantt.updateCollection("resource", resourcesData);
   
    console.log("Resources loaded:", resourcesData.length, "resources");
    console.log("Resource planning data sample:", resourcesData.slice(0, 2).map(r => ({
        name: r.name,
        planning_count: r.planning_dates.length,
        sample_dates: r.planning_dates.slice(0, 3)
    })));
   
    // Forcer le rendu
    gantt.render();
}

// Fonction de mise à jour des tâches parentes
function updateParent(taskId) {
    const task = gantt.getTask(taskId);
    if (task.parent) {
        gantt.updateTask(task.parent);
    }
}

// Fonction de refresh du Gantt
function RefreshGantt(data) {
    const loader = document.createElement("div");
    loader.className = "gantt-refresh-loader";
    loader.innerHTML = "<div>Loading...</div>";
    container.appendChild(loader);

    try {
        const newData = JSON.parse(data);
        
        // Sauvegarde de l'état actuel
        const currentZoom = gantt.ext.zoom.getLevel();
        const scrollState = gantt.getScrollState();
        
        // Rechargement des données
        gantt.clearAll();
        gantt.parse(newData);
        
        // Restauration de l'état
        gantt.ext.zoom.setLevel(currentZoom);
        gantt.scrollTo(scrollState.x, scrollState.y);
        
        // Mise à jour des parents
        gantt.eachTask(function(task) {
            if (task.parent) {
                gantt.updateTask(task.parent);
            }
        });
        
        gantt.render();
    } catch (error) {
        console.error("Error refreshing Gantt:", error);
    } finally {
        setTimeout(() => {
            if (loader.parentNode) {
                container.removeChild(loader);
            }
        }, 300);
    }
}

// =============================================
// GESTION DES ÉVÉNEMENTS GANTT
// =============================================

// Événement : Mise à jour d'une tâche
gantt.attachEvent("onAfterTaskUpdate", function(id, task) {
    if (gantt.isTaskExists(id)) {
        const taskData = {
            id: task.id,
            text: task.text,
            start_date: gantt.date.date_to_str("%Y-%m-%d")(task.start_date),
            duration: task.duration,
            progress: task.progress,
            parent: task.parent,
            job_no: task.job_no,
            job_task_no: task.job_task_no
        };
        console.log("Sending task data:", taskData);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnTaskUpdate", [taskData]);
    }
});

// Événement : Ajout d'une tâche
gantt.attachEvent("onAfterTaskAdd", function(id, task) {
    // Mise à jour du parent dans la hiérarchie
    if (task.parent && task.parent != 0) {
        gantt.updateTask(task.parent);
    }
    
    const taskData = {
        id: task.id,
        text: task.text,
        start_date: gantt.date.date_to_str("%Y-%m-%d")(task.start_date),
        duration: task.duration,
        progress: task.progress || 0,
        parent: task.parent,
        job_no: task.job_no,
        task_type: task.task_type || "Posting"
    };
    
    console.log("Creating new task:", taskData);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnTaskCreate", [taskData]);
});

// Événement : Suppression d'une tâche
gantt.attachEvent("onAfterTaskDelete", function(id) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnTaskDelete", [id.toString()]);
});

// Événement : Clic sur un lien
gantt.attachEvent("onLinkClick", function(id, e) {
    const link = gantt.getLink(id);
    if (link) {
        // Get task names for source and target
        const sourceTask = gantt.getTask(link.source);
        const targetTask = gantt.getTask(link.target);
        const sourceText = sourceTask ? sourceTask.text : link.source.toString();
        const targetText = targetTask ? targetTask.text : link.target.toString();
        
        // Create confirmation message
        const confirmMessage = `Are you sure you want to delete the dependency between "<b>${sourceText}</b>" and "<b>${targetText}</b>"? This may affect the project schedule.`;
        
        // Show custom confirmation dialog using DHTMLX message
        gantt.confirm({
            title: "Delete Dependency",
            text: confirmMessage,
            ok: "Delete",
            cancel: "Cancel",
            callback: function(result) {
                if (result) {
                    // User confirmed, proceed with deletion
                    const linkData = {
                        id: link.id.toString(),
                        source: link.source.toString(),
                        target: link.target.toString()
                    };
                    console.log("Link deletion confirmed:", linkData);
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnLinkDelete", [linkData]);
                } else {
                    console.log("Link deletion cancelled");
                }
            }
        });
        
        // Highlight the link temporarily
        const linkElement = document.querySelector(`.gantt_link_line[data-link-id="${id}"]`);
        if (linkElement) {
            linkElement.classList.add("clicked");
            setTimeout(() => linkElement.classList.remove("clicked"), 1000);
        }
    }
    return true;
});
// == 17. GESTION DES MÉTHODES DU CONTRÔLE ADD-IN ==
// Gestion des méthodes du contrôle Add-In
if (typeof Microsoft !== 'undefined' && Microsoft.Dynamics && Microsoft.Dynamics.NAV) {
    Microsoft.Dynamics.NAV.InvokeExtMethod = function (methodName, args) {
        switch (methodName) {
            case "Refresh":
                if (args && args.length > 0) {
                    RefreshGantt(args[0]);
                }
                break;
            case "ZoomIn":
                if (window.ganttZoomIn) window.ganttZoomIn();
                break;
            case "ZoomOut":
                if (window.ganttZoomOut) window.ganttZoomOut();
                break;
            case "Load":
                if (args && args.length > 0) {
                    window.LoadGanttData(args[0]);
                }
                break;
            case "UpdateResourcePlanning":
                if (args && args.length >= 2) {
                    updateResourcePlanningData(args[0], args[1]);
                }
                break;
            case "ToggleFullscreen":
                if (gantt.ext && gantt.ext.fullscreen) {
                    gantt.ext.fullscreen.toggle();
                }
                break;
            default:
                console.log("Unknown method:", methodName);
        }
    };
}
// =============================================
// INTERFACE AVEC DYNAMICS NAV
// =============================================

// Fonction de chargement des données Gantt
window.LoadGanttData = function(data) {
    try {
        const parsedData = typeof data === 'string' ? JSON.parse(data) : data;
       
        console.log("Loading Gantt data:", {
            tasks: parsedData.data ? parsedData.data.length : 0,
            links: parsedData.links ? parsedData.links.length : 0,
            resources: parsedData.resources ? parsedData.resources.length : 0
        });
       
        // Charger les ressources d'abord
        if (parsedData.resources) {
            loadResourcesData(parsedData.resources);
        }
       
        // Charger les données des tâches
        const taskData = {
            data: parsedData.data || [],
            links: parsedData.links || []
        };
       
        gantt.parse(taskData);
       
        console.log("Gantt data loaded successfully");
       
    } catch (error) {
        console.error("Error loading Gantt data:", error);
    }
};

// Gestion des méthodes du contrôle Add-In
Microsoft.Dynamics.NAV.InvokeExtMethod = function (methodName, args) {
    switch (methodName) {
        case "Refresh":
            if (args && args.length > 0) {
                RefreshGantt(args[0]);
            }
            break;
        case "ZoomIn":
            if (window.ganttZoomIn) window.ganttZoomIn();
            break;
        case "ZoomOut":
            if (window.ganttZoomOut) window.ganttZoomOut();
            break;
        default:
            console.log("Unknown method:", methodName);
    }
};

// =============================================
// INITIALISATION
// =============================================

// Initialisation du contrôle de zoom
initZoomControl(gantt);
// Initialisation du Gantt
gantt.init("gantt_here");
// Créer le bouton fullscreen après l'initialisation
setTimeout(() => {
    createFullscreenButton();
}, 100);
 
// Mise à jour de toutes les tâches parentes après chargement
gantt.eachTask(function(task){
    if (task.parent) {
        gantt.updateTask(task.parent);
    }
});
// Notifier NAV que le Gantt est prêt
if (typeof Microsoft !== 'undefined' && Microsoft.Dynamics && Microsoft.Dynamics.NAV) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlReady", []);
}
console.log("Gantt Control AddIn initialized successfully");