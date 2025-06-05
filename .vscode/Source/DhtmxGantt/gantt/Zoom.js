(function () {
    window.initZoomControl = function (gantt) {
        const zoomConfig = {
            minColumnWidth: 20,
            maxColumnWidth: 150,
            levels: [
                {
                    name: "hour",
                    scale_height: 27,
                    min_column_width: 20,
                    scales: [
                        { unit: "day", format: "%d" },
                        { unit: "hour", format: "%H" },
                    ]
                },
                {
                    name: "day",
                    scale_height: 27,
                    min_column_width: 80,
                    scales: [
                        { unit: "day", step: 1, format: "%d %M" }
                    ]
                },
                {
                    name: "week",
                    scale_height: 50,
                    min_column_width: 50,
                    scales: [
                        {
                            unit: "week", step: 1, format: function (date) {
                                const dateToStr = gantt.date.date_to_str("%d %M");
                                const endDate = gantt.date.add(date, -6, "day");
                                const weekNum = gantt.date.date_to_str("%W")(date);
                                return "#" + weekNum + ", " + dateToStr(date) + " - " + dateToStr(endDate);
                            }
                        },
                        { unit: "day", step: 1, format: "%j %D" }
                    ]
                },
                {
                    name: "month",
                    scale_height: 50,
                    min_column_width: 120,
                    scales: [
                        { unit: "month", format: "%F, %Y" },
                        { unit: "week", format: "Week #%W" }
                    ]
                },
                {
                    name: "quarter",
                    height: 50,
                    min_column_width: 90,
                    scales: [
                        {
                            unit: "quarter", step: 1, format: function (date) {
                                const dateToStr = gantt.date.date_to_str("%M");
                                const endDate = gantt.date.add(gantt.date.add(date, 3, "month"), -1, "day");
                                return dateToStr(date) + " - " + dateToStr(endDate);
                            }
                        },
                        { unit: "month", step: 1, format: "%M" },
                    ]
                },
                {
                    name: "year",
                    scale_height: 50,
                    min_column_width: 30,
                    scales: [
                        { unit: "year", step: 1, format: "%Y" }
                    ]
                }
            ],
            useKey: "ctrlKey",
            trigger: "wheel",
            element: function () {
                return gantt.$root.querySelector(".gantt_task");
            }
        };

        gantt.ext.zoom.init(zoomConfig);
        gantt.ext.zoom.setLevel("week");
        
        // Expose zoom methods to be called from AL
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlAddInReady", []);
    };
    
    // Method to be called from AL trigger for Zoom In
    window.ZoomIn = function() {
        if (window.ganttInstance) {
            window.ganttInstance.ext.zoom.zoomIn();
        }
    };
    
    // Method to be called from AL trigger for Zoom Out
    window.ZoomOut = function() {
        if (window.ganttInstance) {
            window.ganttInstance.ext.zoom.zoomOut();
        }
    };
    
    // Store gantt instance when initialized
    const originalInitZoomControl = window.initZoomControl;
    window.initZoomControl = function(gantt) {
        window.ganttInstance = gantt;
        originalInitZoomControl(gantt);
    };
})();