using AutoMapper;
using login_signup_backend.dtos;
using login_signup_backend.models;

namespace login_signup_backend.utilities.automapper
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<UserForRegistrationDto, User>(MemberList.None)
                .ForMember(dest => dest.UserName,opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.FullName,opt => opt.MapFrom(src => src.FullName))
                .ForMember(dest => dest.Email,opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber))
                .ForMember(dest => dest.Gender, opt => opt.MapFrom(src => src.Gender))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.DateOfBirth))
                ;
        }
    }
}