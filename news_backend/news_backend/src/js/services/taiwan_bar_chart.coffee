angular.module('newsApp').factory 'TaiwanBarChart', [
    '$http',
    '$q',
    'Configuration'
    ($http, $q, Configuration) ->
        factory = {}
        categories = [
            ''
            'Accessories'
            'Audiophile'
            'Camera & Photo'
            'Cell Phones'
            'Computers'
            'eBook Readers'
            'Gadgets'
            'GPS & Navigation'
            'Home Audio'
            'Office Electronics'
            'Portable Audio'
            'Portable Video'
            'Security & Surveillance'
            'Service'
            'Television & Video'
            'Car & Vehicle'
        ]
        dollars = [
            213
            209
            190
            179
            156
            209
            190
            179
            213
            209
            190
            179
            156
            209
            190
            190
        ]
        colors = [
            '#0000b4'
            '#0082ca'
            '#0094ff'
            '#0d4bcf'
            '#0066AE'
            '#074285'
            '#00187B'
            '#285964'
            '#405F83'
            '#416545'
            '#4D7069'
            '#6E9985'
            '#7EBC89'
            '#0283AF'
            '#79BCBF'
            '#99C19E'
        ]
        grid = d3.range(25).map((i) ->
            {
                'x1': 0
                'y1': 0
                'x2': 0
                'y2': 480
            }
        )
        tickVals = grid.map((d, i) ->
            if i > 0
                return i * 10
            else if i == 0
                return '100'
            return
        )
        xscale = d3.scale.linear().domain([
            10
            250
        ]).range([
            0
            722
        ])
        yscale = d3.scale.linear().domain([
            0
            categories.length
        ]).range([
            0
            480
        ])
        colorScale = d3.scale.quantize().domain([
            0
            categories.length
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
        xAxis.orient('bottom').scale(xscale).tickValues tickVals
        yAxis = d3.svg.axis()
        yAxis.orient('left').scale(yscale).tickSize(2).tickFormat((d, i) ->
            categories[i]
        ).tickValues d3.range(17)
        y_xis = canvas.append('g').attr('transform', 'translate(150,0)').attr('id', 'yaxis').call(yAxis)
        x_xis = canvas.append('g').attr('transform', 'translate(150,480)').attr('id', 'xaxis').call(xAxis)
        chart = canvas.append('g').attr('transform', 'translate(150,0)').attr('id', 'bars').selectAll('rect').data(dollars).enter().append('rect').attr('height', 19).attr(
            'x': 0
            'y': (d, i) ->
                yscale(i) + 19
        ).style('fill', (d, i) ->
            colorScale i
        ).attr('width', (d) ->
            0
        )
        transit = d3.select('svg').selectAll('rect').data(dollars).transition().duration(1000).attr('width', (d) ->
            xscale d
        )
        transitext = d3.select('#bars').selectAll('text').data(dollars).enter().append('text').attr(
            'x': (d) ->
                xscale(d) - 200
            'y': (d, i) ->
                yscale(i) + 35
        ).text((d) ->
            d + '$'
        ).style(
            'fill': '#fff'
            'font-size': '14px')

        factory
]