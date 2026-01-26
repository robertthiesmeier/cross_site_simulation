/*******************************************************************************
DGM
*******************************************************************************/

capture program drop dgm
program define dgm, rclass
    
    syntax [,  nstud(integer 10) n(real 1000) ///
                pi0(real .3) pi1(real .3) ///
                a0(real 1) a1(real 1) ///
                b0(real 1) b1(real 1) ///
                c0(real 1) c1(real 1) ///
                tau_pi(real 0) tau_a(real 0) ///
				tau_b(real 0) tau_c(real 0) ///
                sx0(real 1) sx1(real 1) ///
                sy0(real 1) sy1(real 1) ///
				tau_lnsx(real 0.15) tau_lnsy(real 0.15) ///
				alpha0(real 1) alpha1(real 1) tau_alpha(real 0)]

    drop _all

    // total N and study id
    local totN = `n'*`nstud'
    qui set obs `totN'
    gen s = ceil(_n/`n')

    local source = round(ceil(`nstud'/2), 1)
    gen ind = (s > `source')

    // study-specific parameters 
    qui gen pi_s = .
    qui gen a_s = .
    qui gen b_s = .
    qui gen c_s = .
    qui gen sx_s = .
    qui gen sy_s = .
	qui gen alpha_s = .

    forvalues j = 1/`nstud' {
        local pimean = cond(`j'<=`source', `pi0', `pi1')
        local amean = cond(`j'<=`source', `a0', `a1')
        local bmean = cond(`j'<=`source', `b0', `b1')
        local cmean = cond(`j'<=`source', `c0', `c1')
        local sxmean = cond(`j'<=`source', `sx0', `sx1')
        local symean = cond(`j'<=`source', `sy0', `sy1')
		local alphamean = cond(`j'<=`source', `alpha0', `alpha1')

        // draw study-specific values
        scalar eta = rnormal(logit(`pimean'), `tau_pi')
        scalar pik = invlogit(eta)
        scalar ak = rnormal(`amean', `tau_a')
        scalar bk = rnormal(`bmean', `tau_b')
        scalar ck = rnormal(`cmean', `tau_c')
		scalar alphak = rnormal(`alphamean', `tau_alpha')
		scalar lnsxk = rnormal(ln(`sxmean'), `tau_lnsx')
		scalar lnsyk = rnormal(ln(`symean'), `tau_lnsy')
		scalar sxk = exp(lnsxk)
		scalar syk = exp(lnsyk)

        qui replace pi_s = pik if s ==`j'
        qui replace a_s = ak if s ==`j'
        qui replace b_s = bk if s ==`j'
        qui replace c_s = ck if s ==`j'
		qui replace alpha_s = alphak if s == `j'
		qui replace sx_s = sxk if s == `j'
		qui replace sy_s = syk if s == `j'
    }

    // DGM
    gen z = rbinomial(1, pi_s)
    gen x = a_s*z + rnormal(0, sx_s)
    gen y = alpha_s + b_s*x + c_s*z + rnormal(0, sy_s)

end
