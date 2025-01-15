"""
Задание модели для трубопровода
"""
PSI(out::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString) = CoolProp.PropsSI(out, name1, value1, name2, value2, fluid)
@register_symbolic PSI(out::AbstractString, name1::AbstractString, value1::Real, name2::AbstractString, value2::Real, fluid::AbstractString)
sub = "water"
raw""""
Функция для расчета λ - коэффициента гидравлического трения, исходя из значений критерия Рейнольдса (Re),
где d - диаметр трубы, Δ - абсолютная шероховатость, G - массовый расход, T - температура, p - давление, μ - динамический коэффициент вязкости, ρ - относительная плотность
$ Δhₗ = λ_{г} * \dfrac{l}{d} * \dfrac{\line{w^2}}{2*g} $
"""
function λ(d,Δ,G,ρ,μ)
    Re = 4* G * d * ρ / (pi * d^2 * μ * ρ) 
    if Re < 2320
        λ = 64/Re
    elseif 2320 < Re < 3000
        λ = 0.029 + 0.775 * (Re - 2320) * 10^(-5)
    elseif 3000 < Re < 15 * d / Δ
        λ = 0.3264/Re^0.25
    elseif 15 * d / Δ < Re < 300 * d / Δ
        λ = 0.11 * ((d / Δ) + 68 / Re )^0.25
    elseif Re > 300 * d / Δ
        λ = 0.11 * (d / Δ)^0.25
    end
 return λ
end

@register_symbolic λ(d,Δ,G,ρ,μ)

"""
Функция для расчета трубы по перепаду давления Δp,
где параметры
d - диаметр трубы,
l - длина трубы,
Δ - абсолютная шероховатость,
G - массовый расход,
g - ускорение свободного падения,
ρ - относительная плотность,
T - температура,
p - давление
Уравнения:
Δp ~ λ(d,Δ,G,ρ,μ) * l/d * (4 * G /(pi * d^2 * ρ))^2 *ρ / 2 - перепад давления
ΔT ~ 0.0 - изменение температуры равно нулю
"""

@mtkmodel Pipe begin
    @extend OneStream()
    @parameters begin
        d = 0.05
        l = 10.0
        Δ = 0.25 * 10^-3
        g = 9.8
        ρ = 1000.0
        μ = 0.009
    end
    @equations begin
        Δp ~ λ(d,Δ,G,ρ,μ) * l/d * (4 * G /(pi * d^2 * ρ))^2 *ρ / 2
        ΔT ~ 0.0
    end
end
