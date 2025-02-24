---
title: "HSL Isochrone Trams"
excerpt: "An interactive isochrone map showing travel times in the HSL tram system in Helsinki."
header:
  image: "/assets/images/hsl-isochronic-preview-hero.jpg"
  teaser: "/assets/images/hsl-isochronic-preview.jpg"
layout: single
---

## About this project 
Isochronic maps are maps that depict areas of equal travel time. They are often used in urban planning to improve the efficiency of transportation.

The Helsinki Regional Transport Authority ([Helsingin seudun liikenne, HSL](https://www.hsl.fi/)) provides a vast amount of open data to the public through [opendata.fi](https://www.opendata.fi/data/en_GB/organization/helsingin-seudun-liikenne). I have used this data to create an isochronic map.


This project utilises a Leaflet map centered on Helsinki, and visualises tram stops and lines using GeoJSON data.

## A brief technical analysis
### Finding Reachable Stops

This function, `findReachableStops`, determines which stops can be reached from a given starting stop within a specified maximum travel time. It uses a breadth-first search algorithm to explore the stops and their connections. The function maintains a queue to process each stop, a set to track visited stops, and another set to collect reachable stops. For each stop, it checks if the travel time is within the allowed limit and then adds the neighboring stops to the queue for further exploration. Finally, it logs and returns the set of reachable stops.

```javascript
function findReachableStops(startStop, maxTravelTime) {
	const queue = [[startStop, 0, stops[startStop].line]];
	const visited = new Set();
	const reachableStops = new Set();

	while (queue.length > 0) {
    	const [currentStop, currentTime, currentLine] = queue.shift();

    	if (currentTime <= maxTravelTime) {
        	reachableStops.add(currentStop);
        	visited.add(currentStop);

        	stops[currentStop].connections.forEach(neighbor => {
            	if (!visited.has(neighbor)) {
                	const travelTime = stops[currentStop].travelTimes[neighbor];
                	const neighborLine = stops[neighbor].line;
                	const newTime = currentTime + travelTime;
                	queue.push([neighbor, newTime, neighborLine]);
            	}
        	});
    	}
	}

	console.log(`Reachable stops from ${startStop} within ${maxTravelTime} minutes:`, reachableStops);
	return reachableStops;
}
```


### Updating the data on the map.

This function updates the marker color for each stops based on the data returned from `findReachableStops`.

```javascript
function updateReachableStops() {
    const maxTravelTime = parseInt(document.getElementById('travel-time-slider').value, 10);
    const reachableStops = findReachableStops(startStop, maxTravelTime);
    Object.values(markers).forEach(marker => {
        marker.setIcon(greenDotIcon);
    });
    reachableStops.forEach(stopId => {
        if (markers[stopId]) {
            markers[stopId].setIcon(blueDotIcon);
        }
    });
    if (markers[startStop]) {
        markers[startStop].setIcon(redDotIcon);
    }
}
```



<a href="https://kujal.github.io/HSL-isochrone-trams/" class="btn btn--primary">Open Project</a>