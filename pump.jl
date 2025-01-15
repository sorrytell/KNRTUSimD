"""

Задание модели для насоса
Параметры:
G_pump - расход насоса
Уравнения:
G ~ G_pump - расход потока равен расходу насоса
PS: Не доделано не работает
"""

@mtkmodel Pump begin
    @extend OneStream()
    @parameters begin
        G_pump = 0.1
    end
    @equations begin
        G ~ G_pump
        #out.G ~ G_pump
        #G ~ G_pump
        #Δp ~ 0.0
        #ΔT ~ 0.0
    end
end