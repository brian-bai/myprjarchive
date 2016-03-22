#understand minimum payment
def display_minimum_payment(balance = 5000,annualInterestRate = 0.18,monthlyPaymentRate = 0.02):
    totalPaid=0
    for i in range(12):
        minpay=balance*monthlyPaymentRate
        balance-=minpay
        balance+=balance*(annualInterestRate/12.0)
        totalPaid+=minpay
        print ("Month : {}".format(i+1))
        print ("Minimum monthly payment: {0:.2f}".format( minpay))
        print ("Remaining balance: {0:.2f}".format(balance))
    print ("Total paid: {0:.2f}".format(totalPaid))
    print ("Remaining balance: {0:.2f}".format(balance))


#Monthly interest rate = (Annual interest rate) / 12.0
#Monthly unpaid balance = (Previous balance) - (Minimum monthly payment)
#Updated balance each month = (Monthly unpaid balance) + (Monthly interest rate x Monthly unpaid balance)


#get lowest pay by guess and check method
def lowest_pay_guess_check(balance, annualInterestRate):
    pay=0
    diff=balance
    monRate = annualInterestRate/12.0
    while diff > 0:
        updateBalance=balance
        pay  += 10
        for i in range(12):
            monUnPaidBalance= updateBalance-pay
            updateBalance=monUnPaidBalance+monRate*monUnPaidBalance
        diff = updateBalance
    return pay
    
    
#Monthly interest rate = (Annual interest rate) / 12.0
#Monthly payment lower bound = Balance / 12
#Monthly payment upper bound = (Balance x (1 + Monthly interest rate)12) / 12.0


#get lowestPay by bisection search
def lowest_pay_bisection(balance, annualInterestRate):
    bandiff=balance
    monRate = annualInterestRate/12.0
    lowerbound = balance/12.0
    upperbound= balance*(1+monRate)**12/12.0
    pay=lowerbound
    while True:
        updateBalance=balance
        pay=(lowerbound+upperbound)/2.0
        for i in range(12):
            monUnPaidBalance= updateBalance-pay
            updateBalance=monUnPaidBalance+monRate*monUnPaidBalance
        bandiff = updateBalance 
        if abs(bandiff) < 0.01:
            break
        if bandiff > 0:
            lowerbound = pay
        else:
            upperbound = pay
    return pay

def time_guess_check():
    balance = 999999
    annualInterestRate = 0.18
    lowest_pay_guess_check(balance, annualInterestRate)

def time_bisection():
    balance = 999999
    annualInterestRate = 0.18
    lowest_pay_bisection(balance, annualInterestRate)

def main():
    balance = 5000
    annualInterestRate = 0.18
    monthlyPaymentRate = 0.02
    display_minimum_payment(balance,annualInterestRate,monthlyPaymentRate)
    print("Lowest Payment: {}".format(lowest_pay_guess_check(balance, annualInterestRate)))
    print("Lowest Payment: {0:.2f}".format(lowest_pay_bisection(balance, annualInterestRate))) 

if __name__ == '__main__':
    import timeit
    print("Time for guess and check method:")
    print(timeit.timeit("time_guess_check()", setup="from __main__ import time_guess_check",number=100))
    print("Time for guess and bisection search method:")
    print(timeit.timeit("time_bisection()", setup="from __main__ import time_bisection",number=100))
    
    #main()
















































