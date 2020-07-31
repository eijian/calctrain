#!/usr/bin/ruby
#

STEP = 3
NQ = 5
ANS_OK = 2
ANS_NG = 1
ANS_UN = 0
ANSWER = Array.new(NQ, ANS_UN)
LIMIT = [5, 5, 10]
TITLE = [
    "2桁の加減算",
    "3數の乗算",
    "xの一次方程式",
]

def init
    @ans = Array.new(STEP, ANSWER)
    @rand = Random.new
end

def disp_negative(a)
    if a < 0
        "- #{-a}"
    elsif a == 0
        ""
    else
        "+ #{a}"
    end
end

def question_1
    nrange = Range.new(-99, 99)
    #orange = Range.new(0,1)
    x = @rand.rand(nrange)
    y = @rand.rand(nrange)
    a = x + y
    return "#{x} #{disp_negative(y)} = ?　", a.to_s
end

def question_2
    nrange = Range.new(2, 9)
    x = @rand.rand(nrange)
    y = @rand.rand(nrange)
    z = @rand.rand(nrange)
    
    return "#{x} x #{y} x #{z} = ? ", (x * y * z).to_s
end

def question_3
    range0 = Range.new(0, 1)
    range1 = Range.new(1, 9)
    range2 = Range.new(-9, 9)

    as = if @rand.rand(range0) == 0 then -1 else 1 end
    a  = @rand.rand(range1) * as
    b  = @rand.rand(range2)
    cs = if @rand.rand(range0) == 0 then -1 else 1 end
    c  = @rand.rand(range1) * cs
    d  = @rand.rand(range2)

    d2 = d - b
    a2 = a - c

    m = d2.gcd(a2)
    s = if d2 * a2 < 0 then '-' else '' end
    
    ans =
        if a2 == 0
            'nan'           
        elsif d2 == 0
            '0'
        elsif a2.abs / m == 1
            "#{s}#{d2.abs / m}"
        else
            "#{s}#{d2.abs / m}/#{a2.abs / m}"
        end

    return "#{a} x #{disp_negative(b)} = #{c} x #{disp_negative(d)},  x = ? ", ans
end

def question_4
    range0 = Range.new(0, 1)
    range1 = Range.new(1, 9)
    range2 = Range.new(-9, 9)
    range3 = Range.new(1, 25)
    as = if @rand.rand(range0) == 0 then -1 else 1 end
    a0 = @rand.rand(range1)
    bs = if @rand.rand(range0) == 0 then -1 else 1 end
    b0 = @rand.rand(range1)
    c0 = @rand.rand(range2)
    m0 = @rand.rand(range3)
    s  = if (c0 - b0*bs) * as < 0 then '-' else '' end
    d  = c0 - b0*bs
    m  = m0 * d.gcd(a0)
    a  = a0 * m0
    b  = b0 * m0
    c  = c0 * m0

    ans =
        if c - b*bs == 0 then
            '0'
        elsif a == m then
            "#{s}#{(c - b*bs).abs / m}"
        else
            "#{s}#{(c - b*bs).abs / m}/#{a / m}"
        end

    return "#{a * as} x #{if bs < 0 then '-' else '+' end} #{b} = #{c}:  x = ? ", ans
end

def q_and_a(q, a)
    print q
    i = gets.strip
    r = ANS_UN
    if i != ''
        ip = i
        if ip == a then
            r = ANS_OK
            puts "Great!"
        else
            r = ANS_NG
            puts "Bad... answer = #{a}"
        end
    end
    r
end

def question(s)
    q, a = case s
        when 0 then
            question_1
        when 1 then
            question_2
        when 2 then
            question_3
        else
            puts "Wrong step"
        end
    q_and_a(q, a)
end

def rate(a)
    a.size * 100.0 / NQ
end

def report(s, tm)
    resp = @ans[s].select {|a| a != ANS_UN}
    corr = @ans[s].select {|a| a == ANS_OK}
    rep = <<EOF

(STEP #{s+1})
  RESPONSE: #{resp.size}/#{NQ}  #{sprintf("% 3.1f %", rate(resp))}
  CORRECT : #{corr.size}/#{NQ}  #{sprintf("% 3.1f %", rate(corr))}
  TIME    : #{sprintf("% 3.1f sec", tm)} (#{sprintf("% 3.1f sec/Q", tm / resp.size)})"
EOF
    rep
end

def wait_nsec(n)
    n.times do |i|
        print "wait #{n} sec ... #{sprintf("% 2d ", n-i)}\r"
        sleep 1.0
    end
end

def main
    init
    rep = Array.new
    STEP.times do |s|
        puts  ""
        print "STEP #{s+1}: " + TITLE[s] + "(全#{NQ}問): start!"
        puts  "  (LIMIT TIME= #{LIMIT[s] * NQ} sec.)"
        wait_nsec(5)
        t0 = Time.now
        NQ.times do |q|
            printf("Q(% 3d): ", q+1)
            @ans[s][q] = question(s)
        end
        tm = Time.now - t0
        rep << report(s, tm)
    end
    puts ""
    puts "REPORT:"
    STEP.times do |s|
        puts rep[s]
    end
end

main
