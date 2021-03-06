<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>


sr = 44100
ksmps = 10
nchnls = 2
0dbfs = 1.0

garvb		init		0

maxalloc 1, 6

instr 1
kamp		chnget	"amp"
kfrq       chnget    "frqM"
kres        chnget    "resM"
kamp		port		kamp, .001
kfrq port kfrq, .001
kres port kres, .001
kamp /= 3
kenv		linsegr		0, 		 .001, 		1, 	 .01, 	1, 	.1, 0
asig1		oscil		kenv,		cpsmidinn(p4),		p5
asig       moogladder    asig1, kfrq, kres
garvb		+=		asig
		outs		asig*kamp,		asig*kamp
endin

instr 100
kfb chnget "fb"
kfb port kfb, .001
arL, arR	reverbsc	garvb, garvb, kfb, 10000
		outs		arL*.3, arR*.3
        clear   garvb
endin

</CsInstruments>
<CsScore>
f0 z
f1 0 		16384 10 1
f2 0 		16384 10 1 [1/2]  [1/3] [1/4]  [1/5] [1/6]  [1/7] [1/8]  [1/9] [1/10]  [1/11] [1/12]  [1/13] [1/14]  [1/15] 
f3 0 		16384 10 1     0  [1/3]     0  [1/5]     0  [1/7]     0  [1/9]      0  [1/11]      0  [1/13]      0  [1/15] 
f4 0 		16384 10 1     0 -[1/3^2]   0 -[1/5^2]   0 -[1/7^2]   0 -[1/9^2]    0 -[1/11^2]    0 -[1/13^2]    0 -[1/15^2]

i100    0   -1
</CsScore>
</CsoundSynthesizer>
