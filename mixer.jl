"""
Задание модели для смесителя
Уравнения:
in₁.G + in₂.G ~ out.G - сумма расходов входящих первого и второго потока равна расходу на выходе
out.p ~ in₁.p - давление на выходе равно давлению входящего первого потока 
out.p ~ in₂.p - давление на выходе равно давлению входящего второго потока 
out.T ~ (in₁.T * in₁.G + in₂.T * in₂.G) / (in₁.G + in₂.G) - температура на выходе из миксера
"""
@mtkmodel Mixer begin
    @components begin
        in₁ = Stream()
        in₂ = Stream()
        out = Stream()
    end
    @equations begin
        in₁.G + in₂.G ~ out.G
        out.p ~ in₁.p 
        out.p ~ in₂.p 
        out.T ~ (in₁.T * in₁.G + in₂.T * in₂.G) / (in₁.G + in₂.G)
    end
end