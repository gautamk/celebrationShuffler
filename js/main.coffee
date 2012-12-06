Person = Backbone.Model.extend {
    initialize:(name)->
        @.name = name

}

Team = Backbone.Model.extend {

    ### @param members : An array of Person model ###
    initialize : (members) ->
        @.set("members" , members)
        @

    length: ()->
        @.get("members").length

    memberAt: (index)->
        mem = @.get("members")[index]
        if mem is undefined then { name :"" } else mem
}

Teams = Backbone.Collection.extend {
    model:Team
}


TeamsView = Backbone.View.extend {
    initialize:(teams)->
        @.teams = teams
        _.bindAll @, "render"
        @.teams.bind "all", @.render

    largestTeam:()->
        index = 0
        for i in _.range(@.teams.length)
            if @.teams.at(i).length() > @.teams.at(index).length()
                index = i
        @.teams.at(index)

    render: ()->
        renderBuffer = ""
        largestTeamLength = @.largestTeam().length()
        for i in _.range(largestTeamLength)
            renderBuffer += "<tr>"
            for j in _.range(@.teams.length)
                renderBuffer += "<td>"
                name = @.teams.at(j).memberAt(i).name
                renderBuffer += name
                renderBuffer += "</td>"
            renderBuffer += "</tr>"
        @.setElement(renderBuffer)
}

jQuery ->
    window.teams = new Teams()
    
    teamList = JSON.parse("""
        [
            [
                "Mani Doraisamy",
                "John Prawyn",
                "Raghavan",
                "Nadha Kumar",
                "Satish Kumar"
            ],
            [
                "Krishna Kumar",
                "Giragadurai",
                "Selva",
                "Dinesh",
                "Vivek",
                "Adhi"
            ],
            [
                "Naveen",
                "Karthi H",
                "Latha",
                "Lakshmi",
                "Gautam"
            ],
            [
                "Balaji",
                "Raju",
                "Prasanna J",
                "Karthikeyan",
                "Kabilan"
            ],
            [
                "Kamal",
                "Batulla",
                "Santhosh M",
                "Prasanna R",
                "Arunachalam"
            ]
        ]
    """)
    
    for team in teamList
        personArray = []
        for member in team
            personArray.push new Person member
        teams.add new Team personArray
    teamsView = new TeamsView(teams)

    util = {
        tbody : $("#teamTable tbody")
        render : (teamsView)->
            teamsView.render()
            @.tbody.html(teamsView.$el)

        shuffle:(teams)->
            teams.models = _.shuffle(teams.models)

        shuffleAndRender:(teamsView)->
            @.shuffle teamsView.teams
            @.render teamsView


        shuffleTillMaxCount:(teamsView,currentCount,maxCount,interval)->
            @.maxCount = maxCount
            @.currentCount = 0
            self = @
            if maxCount >= currentCount
                setTimeout(()->
                    self.shuffleAndRender(teamsView)
                    self.shuffleTillMaxCount(teamsView,currentCount+1,maxCount,interval)
                    console.log "shuffle"
                    console.log currentCount,maxCount
                ,interval)
    }
    util.render(teamsView)

    $("#shuffleButton").click (e)->
        util.shuffleTillMaxCount(teamsView,0,Math.floor(Math.random()*50),500)


    @

    # teams.add new Team [
    #     new Person("Mani Doraisamy")
    #     new Person("John Prawyn")
    #     new Person("Raghavan")
    #     new Person("Nadha Kumar")
    #     new Person("Satish Kumar")
    # ]

    # teams.add new Team [
    #     new Person("Krishna Kumar")
    #     new Person("Giragadurai")
    #     new Person("Selva")
    #     new Person("Dinesh")
    #     new Person("Vivek")
    #     new Person("Adhi")
    # ]

    # teams.add new Team [
    #    new Person("Naveen")
    #    new Person("Karthi H")
    #    new Person("Latha")
    #    new Person("Lakshmi")
    #    new Person("Gautam")
    # ]

    # teams.add new Team [
    #     new Person("Balaji")
    #     new Person("Raju")
    #     new Person("Prasanna J")
    #     new Person("Karthikeyan")
    #     new Person("Kabilan")
    # ]

    # teams.add new Team [
    #     new Person("Kamal")
    #     new Person("Batulla")
    #     new Person("Santhosh M")
    #     new Person("Karthikeyan")
    #     new Person("Prasanna R")
    #     new Person("Arunachalam")
    # ]