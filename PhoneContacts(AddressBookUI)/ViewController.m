//
//  ViewController.m
//  PhoneContacts(AddressBookUI)
//
//  Created by wanglong on 16/8/11.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "ViewController.h"

#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
@interface ViewController ()<CNContactViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)jump2Contacts:(UIButton *)sender {
    //1.创建对象
    ABPeoplePickerNavigationController *contactVc = [[ABPeoplePickerNavigationController alloc] init];
    
    //2.设置代理
    contactVc.peoplePickerDelegate = self;
    
    //3.跳转到手机联系人
    [self presentViewController:contactVc animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选择其中一个联系人的时候,会执行该代理方法
//如果实现了该方法,那么就不会进入联系人的详细界面
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    /*
     __bridge NSString * : 将CoreFoundation框架的对象所有权交给Foundation框架来使用,但是Foundation框架中的对象并不能管理该对象内存
     __bridge_transfer NSString * : 将CoreFoundation框架的对象所有权交给Foundation来管理,如果Foundation中对象销毁,那么我们之前的对象(CoreFoundation)会一起销毁
     */
    // 1.获取选中联系人的姓名(姓lastname和名firstname)
    CFStringRef firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    CFStringRef lastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *firstName = (__bridge_transfer NSString *)(firstname);
    NSString *lastName = (__bridge_transfer NSString *)(lastname);
    NSLog(@"%@ %@", firstName, lastName);
    
    // 2.获取联系人的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex count = ABMultiValueGetCount(phones);
    for (CFIndex i = 0; i < count; i++) {
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        NSLog(@"label : %@ value : %@", phoneLabel, phoneValue);
    }
    
    // 3.释放不再使用的对象
    CFRelease(phones);
}

//选择一个联系人的具体一个属性,会执行该代理方法
//并且电话不会打出去,退出联系人控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"%s",__func__);
}

//点击了取消按钮 会执行 该方法

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    NSLog(@"%s",__func__);
}

#warning  新的api
//- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //1.创建对象
//    CNContactViewController *contactVc = [[CNContactViewController alloc] init];
//    //2.设置代理
//    contactVc.delegate = self;
//    //3.跳转到手机联系人
//    [self presentViewController:contactVc animated:YES completion:nil];
//}
//
//- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact
//{
//    NSLog(@"contact == %@",contact);
//    
//}
//
//- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
//{
//    NSLog(@"property == %@",property);
//    return YES;
//}
@end
