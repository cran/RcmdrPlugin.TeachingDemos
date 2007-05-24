# Some Rcmdr dialogs for the TeachingDemos package

# last modified: 18 May 2007 by J. Fox

.First.lib <- function(libname, pkgname){
    if (!interactive()) return()
    Rcmdr <- options()$Rcmdr
    plugins <- Rcmdr$plugins
    if ((!pkgname %in% plugins) && !getRcmdr("autoRestart")) {
        Rcmdr$plugins <- c(plugins, pkgname)
        options(Rcmdr=Rcmdr)
        closeCommander(ask=FALSE, ask.save=TRUE)
        Commander()
        }
    }

##.First.lib <- function(libname, pkgname) {
##  Rcmdr <- options()$Rcmdr
##  plugins <- Rcmdr$plugins
##  if (!match(pkgname, plugins, 0))
##    Rcmdr$plugins <- c(plugins, pkgname)
##  options(Rcmdr=Rcmdr)
##
##  Rcmdr:::closeCommander(ask=FALSE)
##  Commander()
##}

simulateConfidenceIntervals <- function(){
    require(TeachingDemos)
    initializeDialog(title=gettextRcmdr("Confidence Intervals for the Mean"))
    muVar <- tclVar("100")
    muEntry <- tkentry(top, width="6", textvariable=muVar)
    sigmaVar <- tclVar("15")
    sigmaEntry <- tkentry(top, width="6", textvariable=sigmaVar)
    nVar <- tclVar("25")
    nEntry <- tkentry(top, width="6", textvariable=nVar)
    repsVar <- tclVar("50")
    repsEntry <- tkentry(top, width="6", textvariable=repsVar)
    confLevelVar <- tclVar(".95")
    confLevelEntry <- tkentry(top, width="6", textvariable=confLevelVar)
    sigmaKnownVar <- tclVar("1")
    sigmaKnownBox <- tkcheckbutton(top, variable=sigmaKnownVar)    
    onOK <- function(){
        closeDialog()
        mu <- as.numeric(tclvalue(muVar))
        if (is.na(mu)){
            errorCondition(recall=simulateConfidenceIntervals, message="Population mean must be a number.")
            return()
            }
        sigma <- as.numeric(tclvalue(sigmaVar))
        if (is.na(sigma) || sigma <= 0){
            errorCondition(recall=simulateConfidenceIntervals, 
                message="Population standard deviation must be a positive number.")
            return()
            }
        n <- round(as.numeric(tclvalue(nVar)))
        if (is.na(n) || n <= 0){
            errorCondition(recall=simulateConfidenceIntervals, message="Sample size must be a positive integer.")
            return()
            }
        reps <- round(as.numeric(tclvalue(repsVar)))
        if (is.na(reps) || reps <= 0){
            errorCondition(recall=simulateConfidenceIntervals, message="Number of samples must be a positive integer.")
            return()
            }
        confLevel <- as.numeric(tclvalue(confLevelVar))
        if (is.na(confLevel) || confLevel <= 0 || confLevel >= 1){
            errorCondition(recall=simulateConfidenceIntervals, message="Confidence level must be between 0 and 1.")
            return()
            }
        sigmaKnown <- as.logical(as.numeric(tclvalue(sigmaKnownVar)))
        command <- paste("ci.examp(mean.sim = ", mu, ", sd = ", sigma, ", n = ", n, ", reps = ", reps, 
            ", conf.level = ", confLevel, ", method = ", if (sigmaKnown) '"z"' else '"t"', ")", sep="")
        doItAndPrint(command)
        tkfocus(CommanderWindow())
        }
    OKCancelHelp(helpSubject="ci.examp")
    tkgrid(tklabel(top, text="Population mean"), muEntry, sticky="e")
    tkgrid(tklabel(top, text="Population standard deviation"), sigmaEntry, sticky="e")
    tkgrid(tklabel(top, text="Sample size"), nEntry, sticky="e")
    tkgrid(tklabel(top, text="Number of samples"), repsEntry, sticky="e")
    tkgrid(tklabel(top, text="Confidence level"), confLevelEntry, sticky="e")
    tkgrid(tklabel(top, text="Population standard deviation known"), sigmaKnownBox, sticky="e")
    tkgrid(buttonsFrame, sticky="w", columnspan=2)
    tkgrid.configure(muEntry, sticky="w")
    tkgrid.configure(sigmaEntry, sticky="w")
    tkgrid.configure(nEntry, sticky="w")
    tkgrid.configure(repsEntry, sticky="w")
    tkgrid.configure(confLevelEntry, sticky="w")
    tkgrid.configure(sigmaKnownBox, sticky="w")    
    dialogSuffix(rows=7, columns=2, focus=muEntry)
    }
    
centralLimitTheorem <- function(){
    require(TeachingDemos)
    initializeDialog(title=gettextRcmdr("Central Limit Theorem"))
    nVar <- tclVar("1")
    nEntry <- tkentry(top, width="6", textvariable=nVar)
    repsVar <- tclVar("10000")
    repsEntry <- tkentry(top, width="6", textvariable=repsVar)
    nclassVar <- tclVar("16")
    nclassEntry <- tkentry(top, width="6", textvariable=nclassVar)
    onOK <- function(){
        closeDialog()
        n <- round(as.numeric(tclvalue(nVar)))
        if (is.na(n) || n <= 0){
            errorCondition(recall=simulateConfidenceIntervals, message="Sample size must be a positive integer.")
            return()
            }
        reps <- round(as.numeric(tclvalue(repsVar)))
        if (is.na(reps) || reps <= 0){
            errorCondition(recall=simulateConfidenceIntervals, message="Number of samples must be a positive integer.")
            return()
            }
        nclass <- round(as.numeric(tclvalue(nclassVar)))
        if (is.na(nclass) || reps <= 0){
            errorCondition(recall=simulateConfidenceIntervals, message="Number of samples must be a positive integer.")
            return()
            }
        command <- paste("clt.examp(n = ", n, ", reps = ", reps, ", nclass =", nclass, ")", sep="")
        doItAndPrint(command)
        tkfocus(CommanderWindow())
        }
    OKCancelHelp(helpSubject="clt.examp")
    tkgrid(tklabel(top, text="Sample size"), nEntry, sticky="e")
    tkgrid(tklabel(top, text="Number of samples"), repsEntry, sticky="e")
    tkgrid(tklabel(top, text="Approximate number of bins for histograms"), nclassEntry, sticky="e")
    tkgrid(buttonsFrame, sticky="w", columnspan=2)
    tkgrid.configure(nEntry, sticky="w")
    tkgrid.configure(repsEntry, sticky="w")
    tkgrid.configure(nclassEntry, sticky="w")
    dialogSuffix(rows=4, columns=2, focus=nEntry)
    }
    
flipCoin <- function(){
    require(TeachingDemos)
    use.rgl <- options("Rcmdr")[[1]]$use.rgl
    if (length(use.rgl) == 0 || use.rgl) require(rgl)
    rgl.open()
    plot.rgl.coin()
    flip.rgl.coin()
    }
    
rollDie <- function(){
    require(TeachingDemos)
    use.rgl <- options("Rcmdr")[[1]]$use.rgl
    if (length(use.rgl) == 0 || use.rgl) require(rgl)
    rgl.open()
    plot.rgl.die()
    roll.rgl.die()
    }
    
powerExample <- function(){
    require(TeachingDemos)
    power.examp()
    run.power.examp()
    }
    
correlationExample <- function(){
    require(TeachingDemos)
    run.cor.examp()
    }
    
linearRegressionExample <- function(){
    require(TeachingDemos)
    put.points.demo()
    }
    
visBinom <- function(){
    require(TeachingDemos)
    vis.binom()
    }
    
visNormal <- function(){
    require(TeachingDemos)
    vis.normal()
    }
    
vist <- function(){
    require(TeachingDemos)
    vis.t()
    }
    
visGamma <- function(){
    require(TeachingDemos)
    vis.gamma()
    }

run.cor.examp <- function (n = 100, seed) 
# slightly modified by J. Fox from the TeachingDemos package
{
    require(TeachingDemos)
    if (!missing(seed)) {
        set.seed(seed)
    }
    x <- scale(matrix(rnorm(2 * n, 0, 1), ncol = 2))
    x <- x %*% solve(chol(cor(x)))
    xr <- range(x)
    cor.refresh <- function(...) {
        r <- slider(no = 1)
        if (r == 1) {
            cmat <- matrix(c(1, 0, 1, 0), 2)
        }
        else if (r == -1) {
            cmat <- matrix(c(1, 0, -1, 0), 2)
        }
        else {
            cmat <- chol(matrix(c(1, r, r, 1), 2))
        }
        new.x <- x %*% cmat
        plot(new.x, xlab = "x", ylab = "y", xlim = xr, ylim = xr)
        title(paste("r = ", round(cor(new.x[, 1], new.x[, 2]), 
            3)))
    }
    slider(cor.refresh, "Correlation", -1, 1, 0.01, 0, title = "Correlation Demo")
    cor.refresh()
}

slider <- function (sl.functions, sl.names, sl.mins, sl.maxs, sl.deltas, 
    sl.defaults, but.functions, but.names, no, set.no.value, 
    obj.name, obj.value, reset.function, title) 
# slightly modified by J. Fox from the TeachingDemos package
{
    if (!missing(no)) 
        return(as.numeric(tclvalue(get(paste("slider", no, sep = ""), 
            env = slider.env))))
    if (!missing(set.no.value)) {
        try(eval(parse(text = paste("tclvalue(slider", set.no.value[1], 
            ")<-", set.no.value[2], sep = "")), env = slider.env))
        return(set.no.value[2])
    }
    if (!exists("slider.env")) 
        slider.env <<- new.env()
    if (!missing(obj.name)) {
        if (!missing(obj.value)) 
            assign(obj.name, obj.value, env = slider.env)
        else obj.value <- get(obj.name, env = slider.env)
        return(obj.value)
    }
    if (missing(title)) 
        title <- "slider control widget"
    require(tcltk)
    nt <- tktoplevel()
    tkwm.title(nt, title)
    tkwm.geometry(nt, "+0+0")
    if (missing(sl.names)) 
        sl.names <- NULL
    if (missing(sl.functions)) 
        sl.functions <- function(...) {
        }
    for (i in seq(sl.names)) {
        eval(parse(text = paste("assign('slider", i, "',tclVar(sl.defaults[i]),env=slider.env)", 
            sep = "")))
        tkpack(fr <- tkframe(nt))
        lab <- tklabel(fr, text = sl.names[i], width = "25")
        sc <- tkscale(fr, from = sl.mins[i], to = sl.maxs[i], 
            showvalue = T, resolution = sl.deltas[i], orient = "horiz")
        tkpack(lab, sc, side = "right")
        assign("sc", sc, env = slider.env)
        eval(parse(text = paste("tkconfigure(sc,variable=slider", 
            i, ")", sep = "")), env = slider.env)
        sl.fun <- if (length(sl.functions) > 1) 
            sl.functions[[i]]
        else sl.functions
        if (!is.function(sl.fun)) 
            sl.fun <- eval(parse(text = paste("function(...){", 
                sl.fun, "}")))
        tkconfigure(sc, command = sl.fun)
    }
    assign("slider.values.old", sl.defaults, env = slider.env)
    tkpack(f.but <- tkframe(nt), fill = "x")
    tkpack(tkbutton(f.but, text = "Exit", command = function() tkdestroy(nt)), 
        side = "right")
    if (!missing(reset.function)){ 
        reset.function <- function(...) print("relax")
        if (!is.function(reset.function)) 
            reset.function <- eval(parse(text = paste("function(...){", 
                reset.function, "}")))
        tkpack(tkbutton(f.but, text = "Reset", command = function() {
            for (i in seq(sl.names)) eval(parse(text = paste("tclvalue(slider", 
                i, ")<-", sl.defaults[i], sep = "")), env = slider.env)
            reset.function()
        }), side = "right")
    }
    if (missing(but.names)) 
        but.names <- NULL
    for (i in seq(but.names)) {
        but.fun <- if (length(but.functions) > 1) 
            but.functions[[i]]
        else but.functions
        if (!is.function(but.fun)) 
            but.fun <- eval(parse(text = paste("function(...){", 
                but.fun, "}")))
        tkpack(tkbutton(f.but, text = but.names[i], command = but.fun), 
            side = "left")
        cat("button", i, "eingerichtet")
    }
    invisible(nt)
}