@time using ModelingToolkit
@time using Plots, DifferentialEquations
@time using ModelingToolkit: t_nounits as t, D_nounits as D
@time using CoolProp
@time using IfElse

include("stream.jl")
include("pipe.jl")
include("tank.jl")
include("splitter.jl")
include("valve.jl")
include("teploobmen.jl")
include("pump.jl")
include("mixer.jl")


"""
модель для двух емкостей: емкость -> труба -> емкость 
функция connect прописывается через потоки в базовых моделях
начальные приближения: объем первой емкости, объем второй емкости, расход сырья в трубе
"""

@mtkmodel Model1 begin  
    @components begin
        tankout = TankOut()
        tankin = TankIn()
        pipe = Pipe(d=0.02)
    end
    @equations begin
        connect(tankout.out, pipe.in)
        connect(pipe.out, tankin.in)
    end
end
@mtkbuild b = Model1()
equations(expand_connections(b))
u0 = [b.tankout.V => 10.0, b.tankin.V => 0.0, b.pipe.G => 10.0]
prob = ODEProblem(b, u0, (0, 1300.0))   # symbolic_u0 = true
sol = solve(prob)
plot(sol)

#считает при t = 4300, но не считает при 4350

"""
модель для теплообмена, две емкости -> теплообменник -> две емкости
начальные приближения: объемы двух начальных емкостей, объемы двух конечных емкостей, расходы в трубах до и после теплообменника, количество тепла подающееся в теплообменник, давление на выходе из теплообменника
"""

@mtkmodel Model2 begin
    @components begin
        tankout₁ = TankOut(T=250)
        tankout₂ = TankOut(T=300)
        tankin₁ = TankIn()
        tankin₂ = TankIn()
        pipein₁ = Pipe(d=0.02)
        pipein₂ = Pipe(d=0.02)
        pipeout₁ = Pipe(d=0.02)
        pipeout₂ = Pipe(d=0.02)
        tepl = Teploobmen()
    end
    @equations begin
        connect(tankout₁.out, pipein₁.in)
        connect(tankout₂.out, pipein₂.in)
        connect(pipein₁.out, tepl.in₁)
        connect(pipein₂.out, tepl.in₂)
        connect(tepl.out₁, pipeout₁.out)
        connect(tepl.out₂, pipeout₂.out)
        connect(pipeout₁.out, tankin₁.in)
        connect(pipeout₂.out, tankin₂.in)
    end
end
@mtkbuild c = Model2()
equations(expand_connections(c))
u0 = [c.tankout₁.V => 10.0, c.tankout₂.V => 10.0, c.tankin₁.V => 0.0, c.tankin₂.V => 0.0, c.pipein₁.G => 3.0, c.pipein₂.G => 3.0, c.pipeout₁.G => 3.0, c.pipeout₂.G => 3.0, c.tepl.Q => 10.0, c.tepl.G₁ => 10.0,  c.tepl.G₂ => 10.0, c.pipeout₁.in.p => 101325.0,c.pipeout₂.in.p => 101325.0 ]
#prob = ODEProblem(c, u0, (0, 2000.0))   # symbolic_u0 = true
sol = solve(prob)
plot(sol)

"""
модель для делителя потока: емкость -> делитель -> две емкости 
начальные приближения: объемы двух конечных емкостей и начальной емкости, расходы в трубах
"""

@mtkmodel Model3 begin
    @components begin
        tankout = TankOut(T=300)
        pipein = Pipe()
        splitter = Splitter()
        pipeout₁ = Pipe()
        pipeout₂ = Pipe()
        tankin₁ = TankIn()
        tankin₂ = TankIn()
    end
    @equations begin
        connect(tankout.out, pipein.in)
        connect(pipein.out, splitter.in)
        connect(splitter.out₁, pipeout₁.in)
        connect(splitter.out₂, pipeout₂.in)
        connect(pipeout₁.out, tankin₁.in)
        connect(pipeout₂.out, tankin₂.in)
    end
end
@mtkbuild d = Model3()
equations(expand_connections(d))
u0 = [d.tankout.V => 10.0, d.tankin₁.V => 0.0, d.tankin₂.V => 0.0, d.pipein.G => 3.0, d.pipein.G => 4.0, d.pipeout₁.G => 2.0, d.pipeout₂.G => 2.0]
prob = ODEProblem(d, u0, (0, 2000.0))   # symbolic_u0 = true
sol = solve(prob)
plot(sol)

"""
модель для: емкость -> труба -> задвижка -> труба -> емкость
начальные приближения: объемы емкостей, расход сырья в трубе
"""

@mtkmodel Model4 begin
    @components begin
        tankout = TankOut()
        pipein = Pipe()
        valve = Valve()
        pipeout = Pipe()
        tankin = TankIn()
    end
    @equations begin
        connect(tankout.out, pipein.in)
        connect(pipein.out, valve.in)
        connect(valve.out, pipeout.in)
        connect(pipeout.out, tankin.in)
    end
end
@mtkbuild e = Model4()
equations(expand_connections(e))
u0 = [e.tankout.V => 10.0, e.tankin.V => 0.0, e.pipeout.G => 2.0]
prob = ODEProblem(e, u0, (0, 2000.0))   # symbolic_u0 = true
sol = solve(prob)
plot(sol)

"""
модель для задвижки: емкость(1/2) -> труба(1/2) -> смеситель -> труба -> емкость
начальные приближения: объемы емкостей, расход сырья в трубе
"""

@mtkmodel Model5 begin
    @components begin
        tankout₁ = TankOut(T=300)
        tankout₂ = TankOut(T=350)
        pipein₁ = Pipe()
        pipein₂ = Pipe()
        mixer = Mixer()
        pipeout = Pipe()
        tankin = TankIn()
    end
    @equations begin
        connect(tankout₁.out, pipein₁.in)
        connect(tankout₂.out, pipein₂.in)
        connect(pipein₁.out, mixer.in₁)
        connect(pipein₂.out, mixer.in₂)
        connect(mixer.out, pipeout.in)
        connect(pipeout.out, tankin.in)
    end
end
@mtkbuild f = Model5()
equations(expand_connections(f))
u0 = [f.tankout₁.V => 10.0, f.tankout₂.V => 10.0, f.tankin.V => 0.0, f.pipein₁.G => 3.0, f.pipein₂.G => 3.0, f.pipeout.G => 6.0]
prob = ODEProblem(f, u0, (0, 2000.0))   # symbolic_u0 = true
sol = solve(prob)
plot(sol)