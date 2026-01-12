/*******************************************************************************
DGM for cross-site imputation simulation study
*******************************************************************************/

capture program drop dgm_het
program define dgm_het, rclass
   
   syntax [,  nstud(integer 10) n(real 1000) ///
               pi(real .3) ///
               a(real 1) b(real 1) c(real 1) ///
               tau_pi(real 0) tau_a(real 0) tau_b(real 0) tau_c(real 0) ///
               sx(real 1) sy(real 1) ]

    drop _all

    // total N
    local totN = `n'*`nstud'
    set obs `totN'

    // study id
    gen int s = ceil(_n/`n')

    gen pi_s = .
    gen a_s = .
    gen b_s = .
    gen c_s = .
    gen sx_s = .
    gen sy_s = .

    forv j = 1/`nstud' {
        scalar eta = rnormal(logit(`pi'), `tau_pi')
        scalar pik = invlogit(eta)
        scalar ak = rnormal(`a', `tau_a')
        scalar bk = rnormal(`b', `tau_b')
        scalar ck = rnormal(`c', `tau_c')

        qui replace pi_s = pik if s==`j'
        qui replace a_s = ak if s==`j'
        qui replace b_s = bk if s==`j'
        qui replace c_s = ck if s==`j'
        qui replace sx_s = `sx' if s==`j'
        qui replace sy_s = `sy' if s==`j'
    }

    // DGM
    gen z = rbinomial(1, pi_s)
    gen x = a_s*z + rnormal(0, sx_s)
    gen y = b_s*x + c_s*z + rnormal(0, sy_s)

end
