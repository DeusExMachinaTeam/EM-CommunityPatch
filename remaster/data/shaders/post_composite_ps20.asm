//////////////////////////////////////////////////////////////////////////////
//
// Workfile: post_composite_ps20.asm
// Created by: Goryh
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
    def c1, 1.44269502, 1, 0, 0
    dcl_texcoord v0.xy
    dcl_2d s0
    dcl_2d s1
    texld r0, v0, s0
    texld r1, v0, s1
    add r1.xyz, r0, r1
    mul r1.xyz, r1.w, -r1
    mul r1.xyz, r1, c1.x
    exp r2.x, r1.x
    exp r2.y, r1.y
    exp r2.z, r1.z
    add r1.xyz, -r2, c1.y
    log r2.x, r1.x
    log r2.y, r1.y
    log r2.z, r1.z
    rcp r0.w, c0.x
    mul r1.xyz, r2, r0.w
    exp r2.x, r1.x
    exp r2.y, r1.y
    exp r2.z, r1.z
    add oC0.xyz, r0, r2
    mov oC0.w, c1.y