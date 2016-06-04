angular.module('newsApp').factory 'TaiwanService', [
    '$http',
    ($http) ->
        factory = {}
        county_json = "static/data/County.json"
        height = 400
        width = 300
        density =
            "臺北市": 9952.60,
            "嘉義市": 4512.66,
            "新竹市": 4151.27,
            "基隆市": 2809.27,
            "新北市": 1932.91,
            "桃園市": 1692.09,
            "臺中市": 1229.62,
            "彰化縣": 1201.65,
            "高雄市": 942.97,
            "臺南市": 860.02,
            "金門縣": 847.16,
            "澎湖縣": 802.83,
            "雲林縣": 545.57,
            "連江縣": 435.21,
            "新竹縣": 376.86,
            "苗栗縣": 311.49,
            "屏東縣": 305.03,
            "嘉義縣": 275.18,
            "宜蘭縣": 213.89,
            "南投縣": 125.10,
            "花蓮縣": 71.96,
            "臺東縣": 63.75
        color = d3.scale.linear().domain([0,10000]).range(["#090","#f00"]);
        projection = d3.geo.mercator()

        d3.selection.prototype.moveToFront = () ->
            console.log(this)
            this.each(()->
                this.parentNode.appendChild(this);
            )

        get_maps_features = (topodata) ->
            topojson.feature(topodata, topodata.objects["County"]).features

        d3_render_maps_color = (path, features) ->
            for i in [features.length-1..0] by -1
                features[i].density = density[features[i].properties.C_Name]
            d3.select("svg").selectAll("path").attr({
                "d": path
                "fill": (d) ->
                    return color(d.density)
            })
#            .on("mouseover", (d) ->
#                $("#name").text(d.properties.C_Name)
#                $("#density").text(d.density)
#            )

        factory.d3_render_ping = (lat, lon, size = 50, duration = 1500) ->
            if not factory.isRendered
                console.error('Taiwan is not rendered yet')
                return
            coordinates = projection([lon, lat])
            console.log coordinates
            circle = d3.select("svg").append('circle').attr(
                cx: coordinates[0],
                cy: coordinates[1],
                r: 15
            ).style(
                fill: 'steelblue',
                stroke: 'blue',
                'stroke-width': 3,
                'fill-opacity': .5
            )
            circle.transition().duration(duration).ease('exp').attr('r', size)
            d3.selectAll('circle').moveToFront()

        d3.json(county_json, (topodata) ->
            features = get_maps_features(topodata)
            d3.select("#map").attr("width", width).attr("height", height)
            projection.scale(4000).center([121, 24]).translate([width/2, height/2])
            path = d3.geo.path().projection(projection)
            d3.select("svg").selectAll("path").data(features).enter().append("path").attr("d",path)
            d3_render_maps_color(path, features)
            factory.isRendered = true
        )
        factory

]