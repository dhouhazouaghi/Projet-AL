// My functions

function Load(data)
{
    gantt.parse(JSON.stringify(data));
}

// Méthode RefreshGantt
function RefreshGantt(data) {
    try {
        console.log("Received data:", JSON.stringify(data, null, 2));
        gantt.clearAll();
        if (data && data.data && data.links) {
            console.log("Parsing data:", JSON.stringify(data, null, 2));
            gantt.parse(data);
        }
        gantt.render();
        return true;
    } catch (e) {
        console.error("Error refreshing Gantt:", e);
        return false;
    }
}