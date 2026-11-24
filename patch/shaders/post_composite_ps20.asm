//////////////////////////////////////////////////////////////////////////////
//
// Workfile: post_composite_ps20.asm
// Created by: ThePlain
//
// Composite final image
//
// $Id: post_composite_ps20.asm,v 1.1 2005/05/23 08:32:27 goryh Exp $
//
//////////////////////////////////////////////////////////////////////////////

/*
ps_2_0
tex t0
tex t1
mul r0, t1, c1
mad r0, t0, c0, r0
mul_x2 r1, c2, t1.w
add r0, r0, r1
*/

ps_3_0
def c3, 0.17, 1.44269502, 1, 0    ; c3.x = output brightness scalar (tune this, 0=no bloom, 1=original ps_3_0)
dcl_texcoord v0.xy
dcl_2d s0
dcl_2d s1
texld r0, v0, s0                  ; r0 = scene
texld r1, v0, s1                  ; r1 = bloom
add r1.xyz, r0, r1                ; scene + bloom
mul r1.xyz, r1.w, -r1             ; * -bloom.alpha (extinction density)
mul r1.xyz, r1, c3.y              ; * 1.44269
exp r2.x, r1.x
exp r2.y, r1.y
exp r2.z, r1.z
add r1.xyz, -r2, c3.z             ; 1 - e^x
log r2.x, r1.x
log r2.y, r1.y
log r2.z, r1.z
rcp r0.w, c0.x                    ; 1/BloomOrigTerm
mul r1.xyz, r2, r0.w
exp r2.x, r1.x
exp r2.y, r1.y
exp r2.z, r1.z
mul r2.xyz, r2, c3.x              ; scale extinction+tone output
add oC0.xyz, r0, r2               ; scene + scaled result
mov oC0.w, c3.z