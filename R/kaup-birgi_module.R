# UI ----------------------------------------------------------------------
kaupbirgi_ui <- function(id) {
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = NS(id, "kaupandi"),
                label = "Kaupandi",
                choices = d |> distinct(kaupandi) |> collect() |> pull(kaupandi)
            ),
            uiOutput(NS(id, "birgi")),
            actionButton(
                inputId = NS(id, "go"),
                label = "Sækja gögn"
            )
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput(NS(id, "line_plot")),
            br(),
            plotlyOutput(NS(id, "bar_plot"))
        )
    )
}


# SERVER ------------------------------------------------------------------
kaupbirgi_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        
        output$birgi <- renderUI({
            
            choices <- d |> 
                filter(kaupandi == !!input$kaupandi) |> 
                count(birgi, wt = kr) |> 
                arrange(desc(n)) |> 
                collect() |> 
                slice(1:30) |>  
                pull(birgi)
            
            selectInput(
                inputId = NS(id, "birgi"),
                label = "Birgi",
                choices = choices, 
                selected = choices[1:3],
                selectize = TRUE, 
                multiple = TRUE
            )
        })
        
        output$line_plot <- renderPlotly({
            p <- d |> 
                filter(
                    kaupandi %in% !!input$kaupandi,
                    birgi %in% !!input$birgi
                ) |> 
                count(kaupandi, birgi, dags_greidslu, wt = kr, name = "kr") |> 
                collect() |> 
                arrange(dags_greidslu) |> 
                mutate(
                    kr = vnv_convert(kr, obs_date = dags_greidslu),
                    kr = slide_index_dbl(kr, dags_greidslu, sum, .before = 365),
                    .by = birgi
                ) |> 
                ggplot(aes(dags_greidslu, kr, group = birgi, col = birgi)) +
                geom_line() +
                geom_point() +
                scale_y_continuous(
                    labels = label_isk(scale = 1e-6)
                ) +
                labs(
                    title = "Útgjöld síðasta ár",
                    x = NULL,
                    y = NULL
                )
            
            ggplotly(
                p
            )
        }) |> 
            bindEvent(
                input$go
            )
        
        output$bar_plot <- renderPlotly({
            
            p <- d |> 
                filter(
                    kaupandi %in% !!input$kaupandi,
                    birgi %in% !!input$birgi
                ) |> 
                count(kaupandi, birgi, dags_greidslu, wt = kr, name = "kr") |> 
                collect() |> 
                arrange(dags_greidslu) |> 
                mutate(
                    kr = vnv_convert(kr, obs_date = dags_greidslu),
                    .by = birgi
                ) |> 
                summarise(
                    kr = sum(kr),
                    .by = birgi
                ) |> 
                mutate(
                    birgi_order = fct_reorder(birgi, kr)
                ) |> 
                ggplot(aes(kr, birgi_order, fill = birgi)) +
                geom_col() +
                scale_x_continuous(
                    labels = label_isk(scale = 1e-6)
                ) +
                theme(
                    legend.position = "none"
                ) +
                labs(
                    title = "Útgjölf yfir allt tímabilið",
                    y = NULL,
                    x = NULL
                )
            
            ggplotly(
                p
            )
            
        }) |> 
            bindEvent(
                input$go
            )
        
    })
}
