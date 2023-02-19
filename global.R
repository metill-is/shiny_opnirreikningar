# PACKAGES ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(arrow)
library(duckdb)
library(metill)
library(bslib)
library(thematic)
library(plotly)
library(slider)
library(visitalaneysluverds)

# THEME AND LOCALE --------------------------------------------------------
theme_set(theme_metill())
thematic_on()
shinyOptions(plot.autocolor = TRUE)
Sys.setlocale("LC_ALL", "is_IS.UTF-8")

bs_global_theme(
    bootswatch = "flatly"
)

bs_global_add_variables(
    primary = "#484D6D",
    secondary = "#969696",
    success = "#969696",
    # danger = "#FF8CC6",
    # info = "#FF8CC6",
    light = "#faf9f9",
    dark = "#484D6D",
    bg = "#faf9f9",
    fg = "#737373",
    "body-bg" = "#faf9f9",
    base_font = "Lato",
    heading_font = "Segoe UI",
    "navbar-brand-font-family" = "Playfair Display",
    code_font = "SFMono-Regular"
)


# SIDEBAR INFO ------------------------------------------------------------
sidebar_info <- paste0(
    br(" "),
    h5("Höfundur:"),
    p("Brynjólfur Gauti Guðrúnar Jónsson"),
    HTML("<a href='https://github.com/metill-is/shiny_opnirreikningar' target='_top'> Kóði og gögn </a><br>")
)


# DATA --------------------------------------------------------------------

d <- open_dataset(
    "Data",
    format = "parquet"
) 
