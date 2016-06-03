angular.module('newsApp').controller('MainCtrl', [
    '$scope',
    ($scope) ->
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
        d3.json("static/data/County.json",(topodata) ->
            features = topojson.feature(topodata, topodata.objects["County"]).features
            color = d3.scale.linear().domain([0,10000]).range(["#090","#f00"]);
            path = d3.geo.path().projection(
                d3.geo.mercator().center([121,24]).scale(6000)
            )
            d3.select("svg").selectAll("path").data(features).enter().append("path").attr("d",path)
            for i in [features.length-1..0] by -1
                features[i].density = density[features[i].properties.C_Name]
            d3.select("svg").selectAll("path").attr({
                "d": path
                "fill": (d) ->
                    return color(d.density)
            }).on("mouseover", (d) ->
                console.log d
                $("#name").text(d.properties.C_Name)
                $("#density").text(d.density)
            )
            d3.select("svg").append('circle').attr(
                cx: 300,
                cy: 60,
                r: 20
            ).style(
                fill: 'steelblue',
                stroke: 'green',
                'stroke-width': 10,
                'fill-opacity': .5
            );
        )
])