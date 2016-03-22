# -*- coding: utf-8 -*-
"""
Created on Wed Jan 14 12:07:08 2015

@author: haku
"""
from credit_payment_bisection import lowest_pay_bisection
from credit_payment_bisection import lowest_pay_guess_check
from nose.tools import assert_almost_equals

def test_guess_check_method():
    assert lowest_pay_guess_check(5000,0.18)==460
    assert lowest_pay_guess_check(320000,0.2)==29160
    assert lowest_pay_guess_check(999999,0.18)==90330

def test_bisection_search():
    assert_almost_equals (lowest_pay_bisection(5000,0.18), 451.63,2)
    assert_almost_equals (lowest_pay_bisection(320000,0.2), 29157.09,2)
    assert_almost_equals (lowest_pay_bisection(999999,0.18), 90325.03,2)
