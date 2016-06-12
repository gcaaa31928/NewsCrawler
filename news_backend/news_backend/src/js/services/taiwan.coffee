angular.module('newsApp').factory 'TaiwanService', [
    '$http',
    '$q',
    'Configuration'
    'TaiwanBarChart'
    ($http, $q, Configuration, TaiwanBarChart) ->
        factory = {}
        factory.max_density = 0
        factory.url = "#{Configuration.server_end_point}/news"
        county_json = "static/data/County.json"
        height = 500
        width = 400
        factory.density =
            "臺北市": 0,
            "嘉義市": 0,
            "新竹市": 0,
            "基隆市": 0,   
            "新北市": 0,
            "桃園市": 0,
            "臺中市": 0,
            "彰化縣": 0,
            "高雄市": 0,
            "臺南市": 0,
            "金門縣": 0,
            "澎湖縣": 0,
            "雲林縣": 0,
            "連江縣": 0,
            "新竹縣": 0,
            "苗栗縣": 0,
            "屏東縣": 0,
            "嘉義縣": 0,
            "宜蘭縣": 0,
            "南投縣": 0,
            "花蓮縣": 0,
            "臺東縣": 0
        map_positions =
            "新北市": [121.6739, 24.91571],
            "高雄市": [120.666, 23.01087],
            "臺中市": [120.9417, 24.23321],
            "臺北市": [121.5598, 25.09108],
            "臺南市": [120.2513, 23.1417],
            "桃園市": [121.2168, 24.93759],
            "新竹市": [120.9647, 24.80395],
            "基隆市": [121.7081, 25.10898],
            "嘉義市": [120.4473, 23.47545],
            "彰化縣": [120.4818, 23.99297],
            "屏東縣": [120.62, 22.54951],
            "雲林縣": [120.3897, 23.75585],
            "苗栗縣": [120.9417, 24.48927],
            "嘉義縣": [120.574, 23.45889],
            "新竹縣": [121.1252, 24.70328],
            "南投縣": [120.9876, 23.83876],
            "宜蘭縣": [121.7195, 24.69295],
            "花蓮縣": [121.3542, 23.7569],
            "臺東縣": [120.9876, 22.98461]
            "金門縣": [118.3186, 24.43679],
            "澎湖縣": [119.6151, 23.56548],
            "連江縣": [119.5397, 26.19737]

        TaiwanBarChart.init(factory.density)
        find_map_position_by_name = (name) ->
            for key, value of map_positions
                if key.indexOf(name) >= 0
                    return value

        set_count_on_region = (count, region) ->
            region = region.replace('台', '臺')
            for key, value of factory.density
                if region == ""
                    continue
                if key.indexOf(region) >= 0
                    factory.density[key] = count
                    factory.max_density = Math.max(count, factory.max_density)
                    return

        projection = d3.geo.mercator()

        d3.selection.prototype.moveToFront = () ->
            this.each(()->
                this.parentNode.appendChild(this);
            )

        get_maps_features = (topodata) ->
            topojson.feature(topodata, topodata.objects["County"]).features

        d3_render_maps_color = (path, features) ->
            color = d3.scale.linear().domain([0, factory.max_density]).range(["green", "red"])
            for i in [features.length-1..0] by -1
                features[i].density = factory.density[features[i].properties.C_Name]
            d3.select("svg").selectAll("path").attr({
                "d": path
                "fill": (d) ->
                    return color(d.density)
            })
#            .on("mouseover", (d) ->
#                $("#name").text(d.properties.C_Name)
#                $("#factory.density").text(d.factory.density)
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


        factory.hover_map_to_ping = (name, size = 50, duration = 200) ->
            if not factory.isRendered
                console.error('Taiwan is not rendered yet')
                return
            name = name.replace('台', '臺')
            coordinate = find_map_position_by_name(name)
            coordinates = projection(coordinate)
            factory.hover_circle.attr(
                cx: coordinates[0],
                cy: coordinates[1],
                r: size
            ).style(
                fill: 'steelblue',
                stroke: 'blue',
                'stroke-width': 3,
                'fill-opacity': .5
            )
            d3.selectAll('circle').moveToFront()

        d3.json(county_json, (topodata) ->
            factory.features = get_maps_features(topodata)
            d3.select("#map").attr("width", width).attr("height", height)
            projection.scale(6000).center([121, 24]).translate([width/2, height/2])
            factory.path = d3.geo.path().projection(projection)
            d3.select("svg").selectAll("path").data(factory.features).enter().append("path").attr("d",factory.path)
            d3_render_maps_color(factory.path, factory.features)
            factory.hover_circle = d3.select("svg").append('circle')
            factory.isRendered = true
        )

        factory.getRegionCount = () ->
            $q((resolve, reject) ->
                url = "#{factory.url}/regions/count/"
                $http.get(url).then((response) ->
                    for region_data in response.data
                        set_count_on_region(region_data.total, region_data.region)
                    d3_render_maps_color(factory.path, factory.features)
                    TaiwanBarChart.update(factory.density)
                    resolve()
                , (response) ->
                    reject(response)
                )
            )

        factory

]