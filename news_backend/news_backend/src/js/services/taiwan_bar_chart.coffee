angular.module('newsApp').factory 'TaiwanBarChart', [
    '$http',
    '$q',
    'Configuration'
    '$timeout'
    ($http, $q, Configuration, $timeout) ->
        factory = {}
        region = ['']
        density = []
        factory.init = (density_data) ->
            for key, value of density_data
                region.push(key)
                density.push(value)

            colors = ['#0000b4', '#0082ca', '#0094ff', '#0d4bcf', '#0066AE', '#074285', '#00187B', '#285964', '#405F83',
                '#416545', '#4D7069', '#6E9985', '#7EBC89', '#0283AF', '#79BCBF', '#99C19E'];
            max_density = d3.max(density)

            grid = d3.range(25).map((i) ->
                {
                    'x1': 0
                    'y1': 0
                    'x2': 0
                    'y2': 480
                }
            )
            tickVals = grid.map((d, i) ->
                i * 30
            )
            factory.xscale = d3.scale.linear().domain([
                0
                max_density + 40
            ]).range([
                0
                722
            ])
            factory.yscale = d3.scale.linear().domain([
                0
                region.length
            ]).range([
                0
                480
            ])
            colorScale = d3.scale.quantize().domain([
                0
                region.length
            ]).range(colors)
            canvas = d3.select('#wrapper').append('svg').attr(
                'width': 900
                'height': 550)
            grids = canvas.append('g').attr('id', 'grid').attr('transform', 'translate(150,10)').selectAll('line').data(grid).enter().append('line').attr(
                'x1': (d, i) ->
                    i * 30
                'y1': (d) ->
                    d.y1
                'x2': (d, i) ->
                    i * 30
                'y2': (d) ->
                    d.y2
            ).style(
                'stroke': '#adadad'
                'stroke-width': '1px')

            xAxis = d3.svg.axis()
            xAxis.orient('bottom').scale(factory.xscale).tickValues tickVals
            yAxis = d3.svg.axis()
            yAxis.orient('left').scale(factory.yscale).tickSize(2).tickFormat((d, i) ->
                region[i]
            ).tickValues d3.range(region.length)
            y_xis = canvas.append('g').attr('transform', 'translate(150,0)').attr('id', 'yaxis').call(yAxis)
            x_xis = canvas.append('g').attr('transform', 'translate(150,480)').attr('id', 'xaxis').call(xAxis)
            chart = canvas.append('g').attr('transform', 'translate(150,0)').attr('id', 'bars').selectAll('rect').data(density).enter().append('rect').attr('height', 15).attr(
                'x': 0
                'y': (d, i) ->
                    factory.yscale(i) + 15
            ).style('fill', (d, i) ->
                colorScale i
            ).attr('width', (d) ->
                0
            )
            #        transit = d3.select('#wrapper svg').selectAll('rect').data(density).transition().duration(1000).attr('width', (d) ->
            #            console.log(xscale d)
            #            xscale d
            #        )



        factory.update = (density_data) ->
            density = []
            for key, value of density_data
                density.push(value)
            transit = d3.select('#wrapper svg').selectAll('rect').data(density).transition().duration(1000).attr('width', (d) ->
                factory.xscale d
            )

        factory
]