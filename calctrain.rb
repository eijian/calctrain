#!/usr/bin/ruby
#

STEP = 4
NQ = 50
ANS_OK = 2
ANS_NG = 1
ANS_UN = 0
ANSWER = Array.new(NQ, ANS_UN)
LIMIT = [5, 5, 10, 10]
TITLE = [
    "2桁の加減算",
    "3數の乗算",
    "xの一次方程式",
    "分数の約分",
]
LOGFILE = 'calctrain.csv'

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
            '--'           
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
    range1 = Range.new(1, 10)
    range2 = Range.new(2, 13)

    a0 = @rand.rand(range1)
    b0 = @rand.rand(range1)
    m0 = @rand.rand(range2)

    m = a0.gcd(b0)
    a = a0 / m
    b = b0 / m
    ans = "#{a}" + (if b == 1 then '' else "/#{b}" end)

    return "#{a0 * m0}/#{b0 * m0} = ? ", ans
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
        when 3 then
            question_4
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
    rep = [
        resp.size, rate(resp),
        corr.size, rate(corr),
        tm, tm / resp.size,
    ]
end

def create_repfile
    if File.exist?(LOGFILE) == false
        File.open(LOGFILE, 'w') do |fp|
            header = <<EOF
DATETIME,STEP,nquestion,res,res%,corr,corr%,time(sec),speed(sec/Q)
EOF
            fp.puts header
        end
    end
end

def display_report(rep)
    # display
    puts ""
    puts "REPORT:"
    STEP.times do |s|
        body = <<EOF
(STEP #{s+1})
  RESPONSE: #{rep[s][0]}/#{NQ}  #{sprintf("% 3.1f %", rep[s][1])}
  CORRECT : #{rep[s][2]}/#{NQ}  #{sprintf("% 3.1f %", rep[s][3])}
  TIME    : #{sprintf("%3.1f sec", rep[s][4])} (#{sprintf("% 3.1f sec/Q", rep[s][5])})
    
EOF
        puts body
    end

    # CSV output
    create_repfile
    dt = Time.now.strftime("%Y%m%d-%H%M%S")
    File.open(LOGFILE, 'a') do |fp|
        STEP.times do |s|
            fp.puts "#{dt},#{s+1},#{NQ},#{rep[s].join(',')}"
        end
    end
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
    display_report(rep)
end

main
