angular.module('newsApp').controller('MainCtrl', [
    '$scope',
    ($scope) ->
        d3.json("static/data/County.json",(topodata) ->
            features = topojson.feature(topodata, topodata.objects["County"]).features
            path = d3.geo.path().projection(
                d3.geo.mercator().center([121,24]).scale(6000)
            )
            d3.select("svg").selectAll("path").data(features).enter().append("path").attr("d",path)
        )
])