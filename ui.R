ui <- shinyUI(
    navbarPage(
        title = "Opnir Reikningar",
        theme = bs_global_get(),
        
        tabPanel(
            title = "Bæði",
            kaupbirgi_ui("kaupbirgi")
        )
        
        
    )
)