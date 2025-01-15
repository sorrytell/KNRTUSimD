"""
Модель для теплообменника 
Уравнение теплопередачи
Параметра:
K-коэффициент теплопередачи
F-площадь теплопередающей поверхности
Переменные(меняются с течеием времни):
G₁(t)- расход первого потока
G₂(t)- расход второго потока
Q(t)- тепловой поток(количество теплоты передаваемое через поверхность теплообмена в 1 сек)
Уравнения:
in₁.G ~ out₁.G #материальный баланс
in₁.G ~ G₁ 
in₂.G ~ out₂.G   
in₂.G ~ G₂
in₁.p ~ out₁.p - давление на выходе и входе первого потока равны
in₂.p ~ out₂.p - давление на выходе и входе второго потока равны
Q ~ K * F * (out₂.T - out₁.T) - расчет теплового потока
out₁.T ~ in₁.T + Q / (PSI("CPMASS", "T", out₁.T, "P", out₁.p, sub) * G₁) - расчет температуры первого потока на выходе
out₂.T ~ in₂.T - Q / (PSI("CPMASS", "T", out₂.T, "P", out₂.p, sub) * G₂) - расчет температуры второго потока на выходе
"""

@mtkmodel Teploobmen begin
    @components begin
        in₁ = Stream()
        out₁ = Stream()
        in₂ = Stream()
        out₂ = Stream()
    end
    @parameters begin
        K = 100.0
        F = 1.0
    end
    @variables begin
        G₁(t)
        G₂(t)
        Q(t)
    end
    @equations begin
        in₁.G ~ out₁.G #материальный баланс
        in₁.G ~ G₁
        in₂.G ~ out₂.G
        in₂.G ~ G₂
        in₁.p ~ out₁.p
        in₂.p ~ out₂.p 
        Q ~ K * F * (out₂.T - out₁.T)
        out₁.T ~ in₁.T + Q / (PSI("CPMASS", "T", out₁.T, "P", out₁.p, sub) * G₁)
        out₂.T ~ in₂.T - Q / (PSI("CPMASS", "T", out₂.T, "P", out₂.p, sub) * G₂)
    end
end