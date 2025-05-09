window.addEventListener('DOMContentLoaded', function () {
    window.ExportToPDF = function () {
        gantt.exportToPDF({
            name: "PlanningProjet.pdf",
            header: "<h2 style='text-align:center;'>Planning Projet</h2>",
            footer: "<p style='text-align:right;'>Exporté le " + new Date().toLocaleDateString('fr-FR') + "</p>",
            locale: "fr",
            skin: "terrace",
            date_format: "%d/%m/%Y"
        });
    };

    window.ExportToPNG = function () {
        gantt.exportToPNG({
            name: "PlanningProjet.png",
            header: "<h2 style='text-align:center;'>Planning Projet</h2>",
            footer: "<p style='text-align:right;'>Exporté le " + new Date().toLocaleDateString('fr-FR') + "</p>",
            locale: "fr",
            skin: "terrace",
            date_format: "%d/%m/%Y"
        });
    };
});
