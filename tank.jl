"""
Задание модели для емкости, из которой выходит сыроевой поток
ρ рассчитывается с использованием T и P через CoolProp
Параметра:
d-диаметр емкости
p-давление
ρ-плотность жидкости
g-ускорение свободного емкости
T-температура
Переменные(меняются с течеием времни):
H(t)-выстота столба жидкости
V(t)-объём жидкости
Уравнения:
H ~ (4 * V)/(pi*d^2) - высота столба жидкости
out.p ~ p + ρ * g * H - давление выходящего потока
D(V) ~ out.G/ρ - изменение объема жидкости в ёмкости
out.T ~ T - температура выходящнго потока
"""
@mtkmodel TankOut begin
    @components begin
        out = Stream()
    end
    @parameters begin
        d = 1.0 # Sets the default resistance
        #H = 10.0
        p = 101320.0
        ρ = 1000.0
        g = 9.8
        T = 300.0
    end
    @variables begin
        H(t)
        V(t)
    end
    @equations begin
        # ρ ~ PSI("D", "T", T, "P", p, sub)
        H ~ (4 * V)/(pi*d^2)
        out.p ~ p + ρ * g * H
        D(V) ~ out.G/ρ
        out.T ~ T
    end
end

"""
Задание модели для емкости, в которую входит сырьевой поток
Параметра:
d-диаметр емкости
Ht-высота уровня в емкости
p-давление
ρ-плотность жидкости
g-ускорение свободного емкости
T-температура
Переменные(меняются с течеием времни):
H(t)-выстота столба жидкости
V(t)-объём жидкости
Уравнения:
H ~ (4 * V)/(pi*d^2) - высота столба жидкости
in.p ~ p + ρ * g * H - давление входящего потока 
D(V) ~ -in.G/ρ - изменение объема жидкости в ёмкости 
"""

@mtkmodel TankIn begin
    @components begin
        in = Stream()
    end
    @parameters begin
        d = 1.0 # Sets the default resistance
        Ht = 10.0
        p = 101320.0
        ρ = 1000.0 
        g = 9.8
    end
    @variables begin
        H(t)
        V(t)
    end
    @equations begin
        H ~ (4 * V)/(pi*d^2)
        in.p ~ p + ρ * g * H
        D(V) ~ -in.G/ρ
    end
end