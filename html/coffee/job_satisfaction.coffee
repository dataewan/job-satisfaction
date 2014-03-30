class JobSatisfactionPlot extends AxesChart
    constructor: (pointsize = 5, yvar = "Satisfaction", hline = "no") ->
        super
        @_pointsize = pointsize
        @_yvar = yvar
        @_hline = hline

    predraw: () ->
        @_label = @_plotarea.append("text")
                    .attr("x", @_width * 0.6)
                    .attr("y", @_height * 0.8)
                    .attr("id", "occupation_label")
                    .style("font-size", "12px")

        if @_hline == "yes"
            @_plotarea.append("line")
                    .attr("x1", 0)
                    .attr("x2", @_width)
                    .attr("y1", () => @y(0))
                    .attr("y2", () => @y(0))
                    .attr("stroke-width", "1px")
                    .attr("stroke", "#aaa")


    _draw: (d,i) ->
        @_plotarea.selectAll("circle")
            .data(d)
            .enter()
            .append("circle")
                .attr("r", @_pointsize)
                .attr("id", (d) => d['id'])
                .attr("cx", (d) => @x(d.Income))
                .attr("cy", (d) => @y(d[@_yvar]))
                .attr("opacity", 0.6)
                .attr("fill", @_colours[0])
                .on("mouseover", (d) => 
                    @tooltip(d)
                )

    postdraw: () ->
        @xaxis()
        @yaxis()

    tooltip: (d) ->
        # reset all the other circle sizes
        @_plotarea.selectAll("circle")
            .transition(100)
            .attr("r", @_pointsize)
            .attr("fill", @_colours[0])

        # find the point the user has selected and make it bigger
        point = @_plotarea.select("circle##{d['id']}")
        point
            .transition(100)
            .attr("r", @_pointsize * 2)
            .attr("fill", @_colours[1])

        @_label.text(d.Occupation)
#@data

d3.csv("data/plot_data.csv")
    .get((error, data) => 
        @data = data
        xvals = _.map(_.pluck(data, "Income"), (i) => +i)
        yvals = _.map(_.pluck(data, "Satisfaction"), (i) => +i)


        unmodified = new JobSatisfactionPlot(pointsize = 5, yvar="Satisfaction")
        unmodified.width(600)
            .height(400)
            .el('#unmodified_plot')
            .data(data)


        unmodified.xscale(
            d3.scale.linear()
                .domain([0, _.max(xvals)])
                .range([0, unmodified.width()])
        )

        unmodified.yscale(
            d3.scale.linear()
                .domain([_.min(yvals), _.max(yvals)])
                .range([unmodified.height(), 0])
        )

        unmodified.draw()

        yvals = _.map(_.pluck(data, "Difference"), (i) => +i)

        corrected = new JobSatisfactionPlot(pointsize = 5, yvar = "Difference", hline = "yes")
        corrected.width(600)
            .height(400)
            .el('#adjusted_plot')
            .data(data)


        corrected.xscale(
            d3.scale.linear()
                .domain([0, _.max(xvals)])
                .range([0, corrected.width()])
        )

        corrected.yscale(
            d3.scale.linear()
                .domain([_.min(yvals), _.max(yvals)])
                .range([corrected.height(), 0])
        )

        corrected.draw()

    )
