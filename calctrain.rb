#!/usr/bin/ruby
#

STEP = 2
NQ = 50
ANS_OK = 2
ANS_NG = 1
ANS_UN = 0
ANSWER = Array.new(NQ, ANS_UN)
LIMIT = [5, 5]
TITLE = [
    "2桁の加減算 (全#{NQ}問)",
    "3數の乗算 (全#{NQ}問)",
]

def init
    @ans = Array.new(STEP, ANSWER)
    @rand = Random.new
end

def question_1
    nrange = Range.new(-99, 99)
    #orange = Range.new(0,1)
    x = @rand.rand(nrange)
    y = @rand.rand(nrange)
    a = x + y
    op = 1
    if y < 0
        op = -op
        y = -y
    end
    return "#{x} #{if op < 0 then '-' else '+' end} #{y} = ?　", a
end

def question_2
    nrange = Range.new(2, 9)
    x = @rand.rand(nrange)
    y = @rand.rand(nrange)
    z = @rand.rand(nrange)
    
    return "#{x} x #{y} x #{z} = ? ", a0 = x * y * z
end

def q_and_a(q, a)
    print q
    i = gets.chomp
    r = ANS_UN
    if i != ''
        ip = i.to_i
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

RESULT (STEP #{s+1}):
  TIME    : #{sprintf("% 3.1f sec", tm)}
  RESPONSE: #{resp.size}/#{NQ}  #{sprintf("% 3.1f %", rate(resp))}
  CORRECT : #{corr.size}/#{NQ}  #{sprintf("% 3.1f %", rate(corr))}
  SPEED   : #{sprintf("% 3.1f sec/Q", tm / resp.size)}
---
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
        puts ""
        puts "STEP #{s+1}: " + TITLE[s] + ": start!"
        puts "  (LIMIT TIME= #{LIMIT[s] * NQ} sec.)"
        wait_nsec(10)
        puts ""
        t0 = Time.now
        NQ.times do |q|
            printf("Q(% 3d): ", q+1)
            @ans[s][q] = question(s)
        end
        tm = Time.now - t0
        rep << report(s, tm)
    end
    STEP.times do |s|
        puts rep[s]
    end
end

main
