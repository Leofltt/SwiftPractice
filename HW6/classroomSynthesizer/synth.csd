<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

/*

Synth.csd

INSTRUMENTS:
INSTR   1: Synth
INSTR  99: Turnoff
INSTR 100: Reverb
INSTR 199: Dummy

*/

maxalloc 1, 4

garvb init 0

garecL init 0
garecR init 0

;synthesizer
instr 1

kact active 1
kpch = cpsmidinn(p5)

printk 1, kpch
printk 1, p5

kamp 		chnget 		"volume"
kpamp       port 		kamp/(400*((kact/8) + 1)), 	 0.01
iatt		chnget		"attack"
idec		chnget		"decay"
isus		chnget		"sustain"
irel		chnget		"release"
kfco		chnget		"cutoff"
kmod        chnget      "mod"
kindx       chnget      "indx"
kmod port kmod, 0.01
kindx port kindx, 0.01

kfco		=			pow(10, kfco)

kenv		linsegr		0, 		 iatt, 		1, 	 idec, 	isus, 	irel, 0

aosc 		foscil 		kenv, 	 kpch, 1, kmod, kindx, p4
afil		moogladder		aosc,		 kfco,		.1
aclip       clip        afil,           0,          .99
garvb		+=			aclip
		outs 			aclip*kpamp, aclip*kpamp
garecR       +=         aclip*kpamp
garecL       +=        aclip*kpamp
endin

;turnoff
instr 99
		turnoff2 		p4, 		 0, 		0
endin

instr 100
kfdb 		chnget 		"reverb"
klev 		chnget 		"level"

avL, avR  reverbsc		garvb, 	 garvb, 	kfdb, 	10000
acL       clip    avL, 0, .99
acR       clip    avR, 0, .99
		outs 			acL*klev, 	 acR*klev
garecL += acL*klev
garecR += acR*klev
        clear           garvb
endin

instr 199
;dummy instr
endin

instr 200
fout "recording.wav", 8, garecL, garecR
clear garecL, garecR
endin

</CsInstruments>
<CsScore>
f1 0 		8192 10 1
f2 0 		8192 10 1 [1/2]  [1/3] [1/4]  [1/5] [1/6]  [1/7] [1/8]  [1/9] [1/10]  [1/11] [1/12]  [1/13] [1/14]  [1/15] 
f3 0 		8192 10 1     0  [1/3]     0  [1/5]     0  [1/7]     0  [1/9]      0  [1/11]      0  [1/13]      0  [1/15] 
f4 0 		8192 10 1     0 -[1/3^2]   0 -[1/5^2]   0 -[1/7^2]   0 -[1/9^2]    0 -[1/11^2]    0 -[1/13^2]    0 -[1/15^2]

i199 0 36000
i100 0 -1
</CsScore>
</CsoundSynthesizer>
