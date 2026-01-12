/*******************************************************************************
DGM
*******************************************************************************/

capture program drop dgm
program define dgm, rclass
    
    syntax [, nstud(integer 10) n(real 1000) ///
            pi0(real .3) pi1(real .3) ///
            a0(real 1) a1(real 1) ///
            b0(real 1) b1(real 1) ///
            c0(real 1) c1(real 1) ///
            tau_pi(real 0) tau_a(real 0) ///
            tau_b(real 0) tau_c(real 0) ///
            sx0(real 1) sx1(real 1) ///
            sy0(real 1) sy1(real 1)]

    drop _all

    // total N and study id
    local totN = `n'*`nstud'
    qui set obs `totN'
    gen stud = ceil(_n/`n')

    local source = round(ceil(`nstud'/2), 1)
    gen ind = (stud > `source')

    // study-specific parameters 
    qui gen pi_s = .
    qui gen a_s = .
    qui gen b_s = .
    qui gen c_s = .
    qui gen sx_s = .
    qui gen sy_s = .

    forvalues j = 1/`nstud' {
        local pimean = cond(`j'<=`source', `pi0', `pi1')
        local amean = cond(`j'<=`source', `a0', `a1')
        local bmean = cond(`j'<=`source', `b0', `b1')
        local cmean = cond(`j'<=`source', `c0', `c1')
        local sxmean = cond(`j'<=`source', `sx0', `sx1')
        local symean = cond(`j'<=`source', `sy0', `sy1')

        // draw study-specific values
        scalar eta = rnormal(logit(`pimean'), `tau_pi')
        scalar pik = invlogit(eta)
        scalar ak = rnormal(`amean', `tau_a')
        scalar bk = rnormal(`bmean', `tau_b')
        scalar ck = rnormal(`cmean', `tau_c')

        qui replace pi_s = pik if stud==`j'
        qui replace a_s = ak if stud==`j'
        qui replace b_s = bk if stud==`j'
        qui replace c_s = ck if stud==`j'
        qui replace sx_s = `sxmean' if stud==`j'
        qui replace sy_s = `symean' if stud==`j'
    }

    // DGM
    gen z = rbinomial(1, pi_s)
    gen x = a_s*z + rnormal(0, sx_s)
    gen y = b_s*x + c_s*z + rnormal(0, sy_s)

end
